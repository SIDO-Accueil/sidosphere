import de.bezier.data.sql.*;
import processing.net.*;

MySQL        qzeMysql;
JSONObject   jsonStats;
String       apple_percent;
String       android_percent;
String       win_percent;
String       autre_percent;
String       qzeStats[];
String       jsonFilename;
int[]        gpercent = new int[11];        //apple = 0; android = 1; windows = 2; autre = 3; 4 = total number of detected since the last half day
int          TEXT_SIZE = 30;
boolean      jsonError;
int          percent_offset = 14;

void setup() {
  jsonFilename = "new.json";
  size(1920, 1080);
  textSize(TEXT_SIZE);
  qzeMysql = new MySQL(this, "qze.fr", "sido", "sido", "passwordSido?8!");
}

void  getStats() {
  try {
    jsonStats = loadJSONObject("new.json");
  }
  catch (Exception e) {
    jsonError = true;
    println("[error] Impossible to get JSON Object. Sorry...");
  }
}

void  display_stats() { 
//  text("Apple iOS:\nAndroid:\nWindows Phone:\nOther (computers): " + "\nNumber of entity present", 8, height * 0.10, 0);
//  text(gpercent[0] + "%\n" + gpercent[1] + "%\n" + gpercent[2] + "%\n" + gpercent[3] + "%\n" + gpercent[4] + "%", TEXT_SIZE * percent_offset, height * 0.10, 0);

  text("Apple iOS:\nAndroid:\nWindows Phone:\nOther (computers): " + "\n", 8, height * 0.10, 0);
  text(jsonStats.getFloat("ios") + "%\n" + jsonStats.getFloat("android") + "%\n" + jsonStats.getFloat("win") + "%\n" + jsonStats.getFloat("other") + "%", TEXT_SIZE * percent_offset, height * 0.10, 0);
}

void draw() {
  background(0);
  fill(255, 255, 255);

  getStats();

  if (qzeMysql.connect()) {
    //-------------------------------------------------
    //-------------------------------------------------
    qzeMysql.query("SELECT (count(manufacturer) / (SELECT count(manufacturer) FROM sniffer WHERE seen_last_half_day = 1) * 100) AS \"iosp\" FROM sniffer WHERE manufacturer like \"Apple%\" AND seen_last_half_day = 1;");
    qzeMysql.next();
    gpercent[0] = qzeMysql.getInt("iosp");
    //-------------------------------------------------
    qzeMysql.query("SELECT (count(manufacturer) / (SELECT count(manufacturer) FROM sniffer WHERE seen_last_half_day = 1) * 100) AS \"ap\" FROM sniffer WHERE (manufacturer LIKE \"%Sony%\" OR manufacturer LIKE \"%HUAWEI%\" OR manufacturer LIKE \"%Samsung%\" OR manufacturer LIKE \"%LG%\" OR manufacturer LIKE \"%HTC%\") AND seen_last_half_day = 1;");
    qzeMysql.next();
    gpercent[1] = qzeMysql.getInt("ap");
    //-------------------------------------------------
    qzeMysql.query("SELECT (count(manufacturer) / (SELECT count(manufacturer) FROM sniffer WHERE seen_last_half_day = 1) * 100) AS \"wpp\" FROM sniffer WHERE (manufacturer LIKE \"%Microsoft%\" OR manufacturer LIKE \"%Nokia%\") AND seen_last_half_day = 1;");
    qzeMysql.next();
    gpercent[2] = qzeMysql.getInt("wpp");
    //-------------------------------------------------
    qzeMysql.query("SELECT (count(manufacturer) / (SELECT count(manufacturer) FROM sniffer WHERE seen_last_half_day = 1) * 100) AS \"autrep\" FROM sniffer WHERE manufacturer NOT LIKE \"%Apple%\" AND manufacturer NOT LIKE \"%Nokia%\" AND manufacturer NOT LIKE \"%Microsoft%\" AND manufacturer NOT LIKE \"%Sony%\" AND manufacturer NOT LIKE \"%HUAWEI%\" AND manufacturer NOT LIKE \"%Samsung%\" AND manufacturer NOT LIKE \"%LG%\" AND manufacturer NOT LIKE \"%HTC%\" AND seen_last_half_day = 1; ");
    qzeMysql.next();
    gpercent[3] = qzeMysql.getInt("autrep");
    //-------------------------------------------------
    qzeMysql.query("SELECT count(*) AS nb_device FROM sniffer WHERE seen_last_half_day = 1;");
    qzeMysql.next();
    gpercent[4] = qzeMysql.getInt("nb_device");
    //-------------------------------------------------
    //-------------------------------------------------
  }
  display_stats();
  qzeMysql.close();
}

