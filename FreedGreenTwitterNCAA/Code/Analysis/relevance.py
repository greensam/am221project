import urllib
from bs4 import BeautifulSoup
import math

# Write a quick function that will grab the relevant roster items, given a team id
def grabroster(teampage):
    url = "http://" + teampage.split('team')[0] + 'team/stats' + teampage.split('team')[1]
    html = urllib.urlopen(url)
    soup = BeautifulSoup(html, "html.parser") 

    names = []
    for tr in soup.find_all('table')[0].find_all('tr')[2:9]:
        for item in tr.find_all('td')[0:1]:
            names.append(str(item.contents[0].contents[0]).split(' ')[1])
    return names

# Create the relevant dictionaries for the stuff coming after
coachurl = "http://espn.go.com/mens-college-basketball/story/_/id/14967272/ranking-ncaa-tournament-coaches-players-1-68"
coachhtml = urllib.urlopen(coachurl)
coachsoup = BeautifulSoup(coachhtml, "html.parser")

# Create a useful dictionary for the ids and the coach
coachdict = {}
for item in coachsoup.find_all('strong'):
    name = str(item.contents[0].split('. ')[1][:-2])
    
    # Get the associated teamid, throwing an exception for Southern (only non-linked team in the database)
    if ',' not in name:
        gid = int(item.find_all('a')[0]['href'].split('id/')[1].split('/')[0])
    else:
        gid = 2582
        name = name.split(',')[0]
    coachdict[gid] = name

# Define a dict with tags for each team
tagdict = {12: ['#Wildcats', '#Arizona', '#GoCats', '#BearDown', '#AZWildcats', '#watchus', '#APlayersProgram'],
           25: ['#Cal', '#LetsDance', '#GoldenBears', '#GoBears', '#CalFamily'],
           38: ['#Buffaloes', '#Colorado', '#GoBuffs'],
           41: ['#Huskies', '#UConn', '#Connecticut', '#bleedblue', '#GoHuskies', '#UConnbasketball', '#UConnnation'],
           43: ['#Bulldogs', '#Yale', '#OneIvy', '#YaleBasketball', '#GoYale'],
           62: ['#RainbowWarriors', '#Hawaii', '#HawaiiMBB', '#RoadWarriors', '#GoBows'],
           66: ['#Cyclones', '#IowaSt', '#IowaState', '#cyclONEnation'],
           84: ['#Hoosiers', '#IU', '#ForIndiana', '#iubb'],
           87: ['#NotreDame', '#NotDoneYet', '#FightingIrish'],
           96: ['#Kentucky', '#Wildcats', '#Cats', '#BigBlueNation'],
           107: ['#HolyCross', '#Crusaders', '#RiseTogether'],
           120: ['#WeWill', '#Maryland', '#Terrapins'],
           127: ['#Spartans', '#GoGreen', '#GoWhite', '#MSU', '#MichiganState'],
           130: ['#Michigan', '#UMich', '#Wolverines', '#Squad100', '#GoBlue'],
           150: ['#Duke', '#BlueDevils', '#GoDuke'],
           153: ['#UNC', '#TarHeels', '#HeelsLockIn', '#UNCBBall'],
           183: ['#Syracuse', '#OrangeCrush', '#CuseMode', '#StLouis'],
           201: ['#Oklahoma', '#OU', '#Sooners', '#BuddyBuckets'],
           204: ['#Beavers', '#OregonState', '#oregonstatebasketball', '#BeaverNation', '#GoBeavs'],
           218: ['#Temple', '#Owls', '#BeatIowa', '#TUMBB'],
           221: ['#Pittsburgh', '#Panthers', '#H2P'],
           222: ['#Villanova', '#Nova', '#NovaMBB', '#NovaNation', '#LetsMarchNova'],
           239: ['#Bears', '#Baylor', '#GoBears'],
           245: ['#TexasA&M', '#Aggies', '#Gigem', '#TAMU', '#12thMan', '#AggieHoops'],
           251: ['#UT', '#Longhorns', '#HookEm', '#Horns'],
           254: ['#Utah', '#Utes', '#goutes', '#Playformore', '#BeatGonzaga'],
           258: ['#Virginia', '#Cavaliers', '#Bulldogs', '#UVA', '#GoHoos'],
           275: ['#Badgers', '#Wisconsin', '#MakeEmBelieve', '#Fieldof64', '#WisconsinBasketball'],
           277: ['#WestVirginia', '#WVU', '#HailWV', '#PressVirginia', '#Mountaineers'],
           2031: ['#LittleRocksTeam'],
           2046: ['#AustinPeay', '#LetsGoPeay', '#16over1'],
           2084: ['#Bison', '#Buffalo', '#UBBulls', '#UBDancing', '#HornsUp'],
           2086: ['#Butler', '#Bulldogs', '#GoDawgs'],
           2132: ['#Cincinnati', '#Cincy', '#BearCats', '#Dancin6'],
           2168: ['#Dayton', '#Flyers', '#TrueTeam', '#GoFlyers'],
           2250: ['#Zags', '#Gonzaga', '#GoZags', '#UnitedWeZag', '#zagup'],
           2294: ['#Hawkeyes', '#Iowa'],
           2305: ['#Jayhawks', '#kubball', '#Kansas', '#RockChalk'],
           2390: ['#Hurricanes', '#Miami', '#BeatBuffalo', '#GoCanes'],
           2393: ['#MiddleTennesseeState', '#MTSU', '#BlueRaiders', '#DancingRaiders'],
           2427: ['#OurTownOurTeam', '#Bulldogs', '#Cinderella', '#UNCAsheville', '#Asheville'],
           2460: ['#NorthernIowa', '#Panthers', '#PantherNation', '#UNI', '#UNIFight'],
           2483: ['#Oregon', '#Ducks', '#GoDucks'],
           2507: ['#Friars', '#PCBB', '#gofriars', '#pcbb', '#dunnions'],
           2550: ['#SetonHall', '#HALLin', '#shbb', '#SHUnited'],
           2571: ['#SDSU', '#Jackrabbits', '#MarchTogether'],
           2603: ['#StJoes', '#Hawks', '#StJosephs', '#THWND'],
           2617: ['#Lumberjacks', '#SFA', '#AxeEm'],
           2670: ['#Rams', '#LetsGoVCU', '#VCU'],
           2692: ['#Wildcats', '#WeberState', '#WeAreWeber', '#BigSkyMBB'],
           2724: ['#Wildcats', '#Shockers', '#Shocktheworld', '#WichitaSt'],
           2739: ['#RP40', '#HLMBB', '#ContinueTheRise', '#GreenBay'],
           2752: ['#Xavier', '#Musketeers', '#LetsGoX', '#LetsMarch'],
           2934: ['#CSUBelieve', '#AllRunners', '#CSUB']}


# Write a quick function that will grab the relevant roster items, given a team id
def grabroster(teampage):
    url = "http://" + teampage.split('team')[0] + 'team/stats' + teampage.split('team')[1]
    html = urllib.urlopen(url)
    soup = BeautifulSoup(html, "html.parser") 

    names = []
    for tr in soup.find_all('table')[0].find_all('tr')[2:9]:
        for item in tr.find_all('td')[0:1]:
            names.append(str(item.contents[0].contents[0]).split(' ')[1])
    return names


# Write a function that will return two lists, each of which contains the last names of the top six players (as measured
# by playing time), the name of the associated coach for the team, and the 
def relvtags(gameid):
    url = 'http://espn.go.com/mens-college-basketball/playbyplay?gameId=' + str(gameid)
    html = urllib.urlopen(url)
    soup = BeautifulSoup(html, "html.parser") 

    # Identify which team is which from the basic page
    teams = soup.find_all('div', {'class', "team-container"}) 
    team1 = teams[0].find_all('span', {'class', 'long-name'})
    team2 = teams[1].find_all('span',{'class', 'long-name'})

    # Find the links to the right pages
    teamlinks = [str("espn.go.com" + teams[0].find_all('a')[0]['href']), 
                 str("espn.go.com" + teams[1].find_all('a')[0]['href'])]

    # Grab the correct roster for the team
    x = []
    for item in teamlinks:
        team = grabroster(item)
        gid = int(item.split('/')[-1])
        team.append(coachdict[gid].split(' ')[1])
        for tag in tagdict[gid]:
            team.append(tag)
            team.append(tag.split('#')[1])
        x.append(team)
    return team1[0].getText(), team2[0].getText(), x

"""
Given relevant keywords for the 2 teams, add what keywords appear for each.
"""
def addrelevancedf(df, eid):
    def textchecksingle(tweet, wset):
        twdict = {w:True for w in tweet.split()}
        return [w for w in wset if w in twdict]
    
    team1, team2, tags = relvtags(eid)

    df['Team1RelWords'] = df['text'].map(lambda t : textchecksingle(t, tags[0]))
    df['Team2RelWords'] = df['text'].map(lambda t : textchecksingle(t,tags[1]))
    
    t1len = len(tags[0])
    t2len = len(tags[1])
    
    df['Team1RelScore'] = df['Team1RelWords'].map(lambda t : float(len(t))/t1len)
    df['Team2RelScore'] = df['Team2RelWords'].map(lambda t : float(len(t))/t2len)
    
    df['Team1Indc'] = df['Team1RelScore'].map(lambda t: math.ceil(t))
    df['Team2Indc'] = df['Team2RelScore'].map(lambda t: math.ceil(t))

    del df['Team1RelWords']
    del df['Team2RelWords']

    df['Team1'] = team1
    df['Team2'] = team2
    
    return df

