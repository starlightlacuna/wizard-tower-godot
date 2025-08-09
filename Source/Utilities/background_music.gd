extends Node
## Global background music handler.

var _audio_stream_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_audio_stream_player = AudioStreamPlayer.new()
	_audio_stream_player.bus = "Music"
	add_child(_audio_stream_player)


## Plays the input [param audio_stream]. If passed in, the stream will be played
## starting at [param from].
func play(audio_stream: AudioStream, from: float = 0.0) -> void:
	_audio_stream_player.stream = audio_stream
	_audio_stream_player.play(from)
