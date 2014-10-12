import unittest
import threading
import pjsua
import time
import agent
import config
import logging
import sys

# Callback to receive events from Call
class PJCallCallback(pjsua.CallCallback):
    
    log=logging.getLogger( "PJCallCallback")
    record_file = config.test_parameters['recordings_dir']+"/"+str(time.time())+".wav"
    
    def __init__(self, call=None):
        pjsua.CallCallback.__init__(self, call)

    # Notification when call state has changed
    def on_state(self):
        
        self.log.debug( "Call is %r", self.call.info().state_text);
        self.log.debug( "last code =%r", self.call.info().last_code); 
        self.log.debug( "("+self.call.info().last_reason + ")");
        
    # Notification when call's media state has changed.
    def on_media_state(self):
        if self.call.info().media_state == pjsua.MediaState.ACTIVE:
            # Connect the call to sound device
            call_slot = self.call.info().conf_slot
            recorder = TestSequenceFunctions.lib.recorder_get_slot(TestSequenceFunctions.lib.create_recorder(self.record_file))
            playback = TestSequenceFunctions.lib.player_get_slot(TestSequenceFunctions.lib.create_player(config.test_parameters['playback_file'], loop=False))
            
            TestSequenceFunctions.lib.conf_connect(call_slot, recorder)
            
            TestSequenceFunctions.lib.conf_connect(playback, call_slot)
            
class MyAccountCallback(pjsua.AccountCallback):
    sem = None

    def __init__(self, account):
        pjsua.AccountCallback.__init__(self, account)

    def wait(self):
        self.sem = threading.Semaphore(0)
        self.sem.acquire()

    def on_reg_state(self):
        if self.sem:
            if self.account.info().reg_status >= 200:
                self.sem.release()
                
    def on_incoming_call(self, call):
        call.answer()

class TestSequenceFunctions(unittest.TestCase):
#    sys.stdout = open(os.devnull, 'w')
    
    lib = pjsua.Lib()
    global acc
    
    AH_Agent = agent.AdaHeads_Agent();
    
    def setUp(self):
        self.assertTrue(self.AH_Agent.isConnected(), "AH_Agent connection failure")
        
        if self.lib == None:
            self.lib = pjsua.Lib()
        
        self.lib.init(log_cfg = pjsua.LogConfig( level=0, filename='PJSUA.log', callback=None, console_level=0))
        self.lib.set_null_snd_dev()
        self.lib.create_transport(pjsua.TransportType.UDP, pjsua.TransportConfig(5060))
        self.lib.start()
        self.acc = self.lib.create_account(pjsua.AccountConfig(config.PBX_Host, "test1", "12345"))
        self.assertTrue(self.acc.is_valid(), "invalid account")
        acc_cb = MyAccountCallback(self.acc)
        self.acc.set_callback(acc_cb)
        acc_cb.wait()
        
        self.assertTrue(acc_cb.account.info().reg_status >= 200, "Could not register")
        
    def test_outbound_call (self):
        my_cb = PJCallCallback(self.acc)
        call = self.acc.make_call("sip:8888@asterisk2.adaheads.com", cb=my_cb)
        # Wait for the call to connect.
        time.sleep(config.test_parameters['outbound_call_timeout'])
        call.hangup()
    
    @classmethod  
    def tearDown (self):
        
        self.AH_Agent.__del__()
        self.lib.hangup_all()
        self.lib.destroy()
        self.lib = None


if __name__ == '__main__':
    logging.basicConfig( stream=sys.stderr )
    logging.getLogger().setLevel( logging.DEBUG )
    unittest.main()
