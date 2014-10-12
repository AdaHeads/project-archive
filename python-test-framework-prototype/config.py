PBX_Host = "asterisk2.adaheads.com"

test_parameters = dict(
    outbound_call_timeout = 5.0,
    playback_file  = "test-wav/infile.wav",
    recordings_dir = "recordings"
)

agents = dict(
    agent1 = dict (
        username = "test1",
        secret   = "12345"
    )
)

callers = dict(
    caller1 = dict (
        username = "test9",
        secret   = "12345"
    )
)
