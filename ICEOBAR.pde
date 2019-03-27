import java.util.Calendar;

PImage backgroundImage;
HashMap<String, Integer> teamColours;
HashMap<String, Destination> destinations;
HashMap<String, Player> players;
String previousKey = "";
boolean saveImages = false;

Calendar gameTimer = Calendar.getInstance();
Calendar endTimer = Calendar.getInstance();
SimpleDateFormat dateFormat = new SimpleDateFormat("y-MM-d HH:mm:ss");

void setup() {
  // Setup view
  size(500, 450);
  background(0);
  frameRate(30);
  
  // Add background
  backgroundImage = loadImage("sydney.png");
  backgroundImage.resize(500, 650);
  image(backgroundImage, 0, 0);

  // Create destinations
  destinations = new HashMap<String, Destination>();
  destinations.put("ICE-O-BAR",                       new Destination(-33.86518408, 151.20332927));
  destinations.put("The Lord Nelson",                 new Destination(-33.85830500, 151.20342200));
  destinations.put("Sydney Observatory",              new Destination(-33.85937000, 151.20463000));
  destinations.put("Argyle Church (Garrison Church)", new Destination(-33.85845200, 151.20543100));
  destinations.put("MCA",                             new Destination(-33.86016900, 151.20926300));
  destinations.put("Harbour bridge pylon",            new Destination(-33.85466600, 151.20956800));
  destinations.put("Sydney Dance Company",            new Destination(-33.85605700, 151.20616500));
  destinations.put("The Establishment",               new Destination(-33.86408600, 151.20760100));
  destinations.put("Wynyard Station Park",            new Destination(-33.86572400, 151.20607000));
  destinations.put("Bungalow 8",                      new Destination(-33.86592700, 151.20159200));
  destinations.put("Museum of Sydney",                new Destination(-33.86357200, 151.21149400));

  // Set team colours
  teamColours = new HashMap<String, Integer>();
  teamColours.put("1", 0xFFFFFF00);
  teamColours.put("2", 0xFFFF00FF);
  teamColours.put("3", 0xFF00FFFF);
  teamColours.put("4", 0xFFFF0088);
  teamColours.put("5", 0xFF00FF00);
  teamColours.put("6", 0xFF0088FF);
  teamColours.put("7", 0xFF88FF00);
  teamColours.put("8", 0xFFFF0000);

  // Load players
  players = loadPlayers("data.csv", teamColours);

  // Setup timer
  try {
    gameTimer.setTime(dateFormat.parse("2010-07-23 16:17:00"));
    endTimer.setTime(dateFormat.parse("2010-07-23 17:05:00"));    
  }
  catch (Exception e) {
  }
}

void draw() {
  // Redraw semitransparent backgroun to hide old positions
  tint(255, 128);
  image(backgroundImage, 0, 0);

  // Draw destinations
  drawDestinations(destinations);

  String timeKey = dateFormat.format(gameTimer.getTime());
  
  // Draw position of each player
  for (Map.Entry<String, Player> p : players.entrySet()) {
    Player player = p.getValue();

    // Draw player position
    Location location = player.draw(timeKey);
    
    if (!previousKey.equals("")) {
      player.lineFromPreviousPosition(timeKey, previousKey);
    }

    // Update nearby locations
    updateDestinationColour(destinations, location, player.colour);
  }
  
  previousKey = timeKey;

  // Increment game timer
  gameTimer.add(Calendar.SECOND, 5);
  
  // Check exit condition
  if (gameTimer.compareTo(endTimer) == 1) {
    println("Finished");
    noLoop();
  } else if (saveImages) {
    saveFrame("output/point-######.png");
    // $ convert -loop 0 -delay 1x60 *.png animation.gif
    //  /Applications/ffmpeg -framerate 60 -i output/point-%06d.png -c:v libx264 -vf "format=yuv420p" video.mp4
  }
}
