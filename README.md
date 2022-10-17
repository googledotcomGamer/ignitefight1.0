# Rabid Hole Punch Godot

Godot plugin that, [alongside the Rabid Hole Punch Server](https://gitlab.com/RabidTunes/rabid-hole-punch-server), allows peer to peer communication via UDP Hole Punching between devices that are behind NAT

**Please note that although UDP Hole Punching is a great technique it is not successful 100% of the time due to different NAT and firewall configurations**

## Installation and configuration

Clone this repository and copy the addons folder into your Godot Project.

Go to Project -> Project Settings -> Plugins -> Enable RabidHolePuncher

The plugin will be always enabled as a singleton, but you have to configure it first to use it.

Inside Godot, open the RabidHolePuncher.tscn file which will be inside "addons/rabidholepuncher/".

Click the node RabidHolePuncher which will be the root of this scene and check the node variables "Relay Server Address" and "Relay server port" and replace those with your relay server address and port (remember you **have** to set up a public accessible machine with the [Rabid Hole Punch Server](https://gitlab.com/RabidTunes/rabid-hole-punch-server) running for this to work)

## Usage

You have [an example project here](https://gitlab.com/RabidTunes/rabid-hole-punch-example) if you prefer checking directly how it works.

The RabidHolePuncher singleton has a couple signals and methods to get you running. To understand the requests sent by the plugin to the server [you can check the server's readme](https://gitlab.com/RabidTunes/rabid-hole-punch-server/-/blob/main/README.md)

### Methods

#### `create_session(session_name: String, player_name: String, max_players: int = 4, session_pass: String = "")`

Call this method to create a session. This will send the host session request with the given parameters


#### `join_session(session_name: String, player_name: String, max_players: int = 4, session_pass: String = "")`

Call this method to join a session. This will send the connect session request with the given parameters


#### `kick_player(player_name: String)`

Call this method to kick a player from session by its name. Only works if you are already in a session and if you are host, otherwise it does nothing


#### `start_session()`

Call this method to start a session. Only works if you are currently in a session.


#### `exit_session()`

Call this method to exit the current session


#### `is_host()`

Returns true if you previously called `create_session()` as in that case you'd be the host. It does also return true if you connected to a session but the host left and you were the next on the list, so you'd be the new host.

#### `get_player_name()`

Returns the player name you inputted when calling either `create_session()` or `join_session()`

### Signals

#### `holepunch_progress_update(type, session_name, player_names)`

This signal is emitted anytime there is an event regarding the hole punch process. `session_name` is a String with the name of the session, `player_names` is an array of Strings with the player names inside the session (note: it is always safe to assume that the first element in the list is the host).

`type` can be one of the following default Strings (they are all defined as constants in the RabidHolePunch singleton):

| Type constant | Meaning |
| ------ | ------ |
| STATUS_SESSION_CREATED | Emitted after receiving server confirmation that the session has been created |
| STATUS_SESSION_UPDATED | Emitted after receiving a list of players different than the current list of players (example when a user joins or leaves the session) |
| STATUS_STARTING_SESSION | Emitted after the host starts the session and you receive the start session message from the server |
| STATUS_SENDING_GREETINGS | Emitted at the beggining of the "sending greetings" phase |
| STATUS_SENDING_CONFIRMATIONS | Emitted at the beggining of the "sending confirmations phase |

#### `holepunch_failure(error)`

This signal is emitted either when the server sends an error response or the client detects an error state. The RabidHolePunch singleton has the following constants to describe the errors:

Server errors:
| Error constant | Description |
| ------ | ------ |
| ERR_REQUEST_INVALID | One of the requests sent was invalid. It is unlikely you'll ever receive this, but bugs can happen |
| ERR_SESSION_EXISTS | Session already exists |
| ERR_SESSION_NON_EXISTENT | Session does not exist (when connecting, for example) |
| ERR_SESSION_PASSWORD_MISMATCH | Incorrect password for session |
| ERR_SESSION_SINGLE_PLAYER | Tried to start a single player session |
| ERR_SESSION_FULL | Session cannot have more players |
| ERR_SESSION_PLAYER_NAME_IN_USE | Player name is already in use in the given session |
| ERR_SESSION_PLAYER_NON_EXISTENT | Player does not exist in the current session (for kick command, for example) |
| ERR_SESSION_PLAYER_NON_HOST | Player is not host, probably tried to execute host command as non host |
| ERR_SESSION_PLAYER_KICKED_BY_HOST | Player was kicked by host |
| ERR_SESSION_PLAYER_EXIT | Player exited session |
| ERR_SESSION_NOT_STARTED | Session has not started yet. You shouldn't receive this message unless you did something really funky |
| ERR_SESSION_TIMEOUT | Session timed out (they have a maximum time to live) |
| ERR_PLAYER_TIMEOUT | Player timed out (server didn't receive ping in a long time from player) |

Client errors:
| Error constant | Description |
| ------ | ------ |
| ERR_SERVER_TIMEOUT | Server is not answering and it timed out |
| ERR_UNREACHABLE_SELF | After greetings phase, the client did not receive any greeting so it is considered unreachable |
| ERR_HOST_NOT_CONFIRMED | After confirmations phase, the host did not confirm their port therefore it is considered unreachable and session cannot start |


#### `holepunch_success(self_port, host_ip, host_port)`

Signal emitted when the holepunch process is successful. Parameters are different on host and clients.

Host does only receive self_port, the other parameters are set to null.

Clients receive self_port, host_ip and host_port.

Use these parameters to start a peer to peer network. [You can check the example to see how to do so.](https://gitlab.com/RabidTunes/rabid-hole-punch-example)


