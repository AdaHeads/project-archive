part of bob;

Connection conn;
click_handlers CH;

void initialize()
{
  conn = new Connection(Configuration.WebSocket_URL);
  conn.Initialize();

  CH = new click_handlers();
  CH.Initialize();

  Call_List = new List<Call>();
}