import de.bezier.data.sql.*;
import processing.net.*;

JSONObject json;
JSONObject perso;
int nbIn = 0, nbFixe = 0, nbSup = 0;

boolean depop(int pos)
{
  if (second() % 10 == 0 && nbFixe > 60)
   {
     nbFixe -= 3;
     nbIn = 3;
     while (pos < nbCubesW - 1 && WireC[pos].id != 0)
       pos++;
     while (nbIn != 0 && pos > 0)
     {
       WireC[pos].goOut = true;
       pos--;
       nbIn--;
     }
     return true;
   }
  if (nbFixe < 100)
    return false;
  else
    return true;
}

void parseNb(JSONObject json)
{
  int tmp = 0, tmp2;
  int i = 0;
  int pos = 0;

  tmp = json.getInt("nb");
  if (!depop(pos) && nbFixe > 0)
  {
    nbIn = tmp - nbSup;
    if (nbIn > 0)
    {
      while (i < nbCubesW && i < nbIn)
      {
        pos = 0;
        while (pos < nbCubesW && WireC[pos].id != 0)
          pos++;
        pos = (pos >= 100 ? 99 : pos);
        WireC[pos].id = i + 1;
        WireC[pos].isPop = true;
        nbFixe++;
        i++;
      }
    } 
    else if (nbIn < 0)
    {
      pos = 0;
      nbIn = nbSup - tmp;
      while (pos < nbCubesW - 1 && WireC[pos].id != 0)
        pos++;
      while (nbIn > 0 && pos > 0)
      {
        WireC[pos - 1].goOut = true;
        pos--;
        nbIn--;
        nbFixe--;
      }
    }
  }
  nbSup = tmp;
}


void parsColor(int j, JSONObject perso)
{
  JSONObject colo = perso.getJSONObject("color");

  int r = colo.getInt("r");
  int g = colo.getInt("g");
  int b = colo.getInt("b");
  Cubes[j].setColor(r, g, b);
  if (Cubes[j].fromTable)
  {
    Cubes[j].clr = r;
    Cubes[j].clg = g;
    Cubes[j].clb = b;
  }
}


void parseVertex(int j, JSONObject perso)
{
  int k = 0;

  JSONObject vertex = perso.getJSONObject("nodes");
  while (k < 8)
  {
    JSONObject vectors = vertex.getJSONObject("node" + (k + 1));
    Float x = vectors.getFloat("x") * 10;
    Float y = vectors.getFloat("y") * 10;
    Float z =   vectors.getFloat("z") * 10;
    Cubes[j].addVector(x, y, z, k);
    k++;
  }
}

void parseIn(JSONObject json)
{
  int j = 0;
  JSONArray in = json.getJSONArray("in");

  while (j < in.size () && j < nbCubes)
  {
    perso = in.getJSONObject(j);
    String id = perso.getString("id");
    if (!checkId(id, false, true))
    {
      while (j < nbCubes && Cubes[j].id != null)
        j++;
      boolean fromTable = perso.getBoolean("fromTable");
      int twitter = perso.getInt("tweets");
      Cubes[j].setBase(id, twitter, fromTable);
      if (!fromTable)
        Cubes[j].goIn = true;
      parsColor(j, perso);
      parseVertex(j, perso);
    } else
      j++;
  }
}

void parseOut(JSONObject json)
{
  int j = 0;
  JSONArray out = json.getJSONArray("out");

  while (j < out.size ())
  {
    JSONObject obj = out.getJSONObject(j);
    String id = obj.getString("id");
    checkId(id, true, false);
    j++;
  }
}

void loadLegend()
{
  JSONObject json;

  GetRequest get = new GetRequest("http://sido.qze.fr:3000/stats");
  get.send();
  json = parseJSONObject(get.getContent());
  println(get.getContent());
  gpercent[0] = json.getFloat("ios");
  gpercent[1] = json.getFloat("android");
  gpercent[2] = json.getFloat("win");
  gpercent[3] = json.getFloat("other");
  gpercent[4] = json.getFloat("iot");
  gpercent[5] = json.getFloat("sido");
}

void load()
{
  JSONObject json;
  /*
  json = loadJSONObject("in.json");
   */
  GetRequest get = new GetRequest("http://sido.qze.fr:3000/sidomes");
  get.send();
  json = parseJSONObject(get.getContent());
  println(get.getContent());
  parseNb(json);
  parseIn(json);
  parseOut(json);
}

void deleteCube(String id)
{
  int i = 0;

  while (i < nbCubes)
  {
    if (id.equals(Cubes[i].id))
    {
      Cubes[i].setGoOut(true);
      return;
    }
    i++;
  }
}

void refresh(int j)
{
  boolean fromTable = perso.getBoolean("fromTable");
  int twitter = perso.getInt("tweets");
  Cubes[j].setBase(Cubes[j].id, twitter, fromTable);
  if (!fromTable)
    Cubes[j].goIn = true;
  parsColor(j, perso);
  parseVertex(j, perso);
}

boolean checkId(String id, boolean out, boolean ref)
{
  int i = 0;

  while (i < nbCubes)
  {
    if (Cubes[i].id != null && id.equals(Cubes[i].id))
    {
      if (ref)
        refresh(i);
      if (out)
        Cubes[i].goOut = true;
      return true;
    }
    i++;
  }
  return false;
}

