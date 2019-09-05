//
//  FirstViewController.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 02/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//

import UIKit

class Node {
    var visited = false
    var stations: [Station] = []
}

class Station {
    public let to: Node
    public let weight: Int
    
    public init(to node: Node, weight: Int) {
        assert(weight >= 0, "weight has to be equal or greater than zero")
        self.to = node
        self.weight = weight
    }
}

class MyNode: Node {
    var name: String
    
    init(name: String) {
        self.name = name
        super.init()
    }
}

class Path {
    public let cumulativeWeight: Int
    public let node: Node
    public let previousPath: Path?
    
    init(to node: Node, via connection: Station? = nil, previousPath path: Path? = nil) {
        if
            let previousPath = path,
            let viaConnection = connection {
            self.cumulativeWeight = viaConnection.weight + previousPath.cumulativeWeight
        } else {
            self.cumulativeWeight = 0
        }
        
        self.node = node
        self.previousPath = path
    }
}

extension Path {
    var array: [Node] {
        var array: [Node] = [self.node]
        
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.node)
            
            iterativePath = path
        }
        
        return array
    }
}



class JPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fromPickeview: UIPickerView!
    @IBOutlet weak var toPickerview: UIPickerView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var journeyText: UITextView!
    @IBOutlet weak var journeyButton: UIButton!
    
    //these will be where the user picks the station
    var sourceNode = MyNode(name: "")
    var destinationNode = MyNode(name: "")
    
    
    //all stations in an array for use in a pickerview
    
    var allStations = ["Acton Town", "Aldgate", "Aldgate East", "All Saints", "Alperton", "Amersham",
                       "Angel", "Archway", "Arnos Grove", "Arsenal","Baker Street", "Balham","Bank",
                       "Barbican", "Barking", "Barkingside", "Barons Court", "Bayswater", "Beckton",
                       "Beckton Park", "Becontree", "Belsize Park", "Bermondsey", "Bethnal Green",
                       "Blackfriars", "Blackhorse Road", "Blackwall", "Bond Street", "Borough", "Boston Manor",
                       "Bounds Green", "Bow Church", "Bow Road", "Brent Cross", "Brixton", "Bromley-By-Bow",
                       "Buckhurst Hill", "Burnt Oak", "Caledonian Road", "Camden Town", "Canada Water",
                       "Canary Wharf", "Canning Town", "Cannon Street", "Canons Park", "Chalfront & Latimer",
                       "Chalk Farm", "Chancery Lane", "Charing Cross", "Chesham", "Chigwell", "Chiswick Park",
                       "Chorleywood", "Clapham Common", "Clapham North", "Clapham South", "Cockfosters",
                       "Colindale", "Colliers Wood", "Covent Garden", "Crossharbour & London Arena", "Croxley",
                       "Custom House", "Cutty Sark", "Cyprus", "Dagenham East", "Dagenham Heathway", "Debden",
                       "Deptford Bridge", "Devons Road", "Dollis Hill", "Ealing Broadway", "Ealing Common",
                       "Earl's Court", "East Acton", "East Finchley", "East Ham", "East India", "East Putney",
                       "Eastcote", "Edgware", "Edgware Road", "Elephant & Castle", "Elm Park", "Elverson Road",
                       "Embankment", "Epping", "Euston", "Euston Square", "Fairlop", "Farringdon",
                       "Finchley Central", "Finchley Road", "Finsbury Park", "Fulham Broadway", "Gallions Reach",
                       "Gants Hill", "Gloucester Road", "Golders Green", "Goldhawk Road", "Goodge Street",
                       "Grange Hill", "Great Portland Street", "Green Park", "Greenford", "Greenwich",
                       "Gunnersbury", "Hainault", "Hammersmith", "Hampstead", "Hanger Lane", "Harlesden",
                       "Harrow & Wealston", "Harrow-On-The-Hill", "Hatton Cross", "Heathrow Terminal 4",
                       "Heathrow Terminal 1, 2 & 3", "Heathrow Terminal 5", "Hendon Central", "Heron Quays",
                       "High Barnet", "High Street Kensington", "Highbury & Islington", "Highgate", "Hillingdon",
                       "Holborn", "Holland Park", "Holloway Road", "Hornchurch", "Hounslow Central",
                       "Hounslow East", "Hounslow West", "Hyde Park Corner", "Ickenham", "Island Gardens",
                       "Kennington", "Kensal Green", "Kensinton (Olympia)", "Kentish Town", "Kenton",
                       "Kew Gardens", "Kilburn", "Kilburn Park", "King's Cross St. Pancras", "Kingsbury",
                       "Knightsbridge", "Ladbroke Grove", "Lambeth North", "Lancaster Gate", "Latimer Road",
                       "Leicester Square", "Lewisham", "Leyton", "Leytonstone", "Limehouse", "Liverpool Street",
                       "London Bridge", "Loughton", "Maida Vale", "Manor House", "Mansion House", "Marble Arch",
                       "Marylebone", "Mile End", "Mill Hill East", "Monument", "Moor Park", "Moorgate", "Morden",
                       "Mornington Cresent", "Mudchute", "Neasden", "New Cross", "New Cross Gate", "Newbury Park",
                       "North Acton", "North Ealing", "North Greenwich", "North Harrow", "North Wembley",
                       "Northfields", "Northolt", "Northwood Hills", "Notting Hill Gate", "Oakwood", "Old Street",
                       "Osterley", "Oval", "Oxford Circus", "Paddington", "Park Royal", "Parsons Green",
                       "Perivale", "Picadilly Circus", "Pimlico", "Pinner", "Plaistow", "Poplar", "Preston Road",
                       "Prince Regent", "Pudding Mill Lane", "Putney Bridge", "Queen's Park", "Queensbury",
                       "Queensway", "Ravenscourt Park", "Rayners Lane", "Redbridge", "Regents Park", "Richmond",
                       "Rickmansworth", "Roding Valley", "Rotherhithe", "Royal Albert", "Royal Oak",
                       "Royal Victoria", "Ruislip", "Ruislip Gardens", "Ruislip Manor", "Russel Square",
                       "Seven Sisters", "Shadwell", "Shephards Bush", "Shoreditch", "Sloane Square", "Snaresbrook",
                       "South Ealing", "South Harrow", "South Kensington", "South Kenton", "South Quays",
                       "South Ruislip", "South Wimbledon", "South Woodford", "Southfields", "Southgate",
                       "Southwark", "St. Jame's Park", "St. John's Wood", "St. Paul's", "Stamford Brook",
                       "Stanmore", "Stephney Green", "Stockwell", "Stonebridge Park", "Stratford", "Sudbury Hill",
                       "Sudbury Town", "Surrey Quays", "Swiss Cottage", "Temple", "Theydon Bois", "Tooting Bec",
                       "Tooting Broadway", "Tottenham Court Road", "Tottenham Hale", "Totteridge & Whetstone",
                       "Tower Gateway", "Tower Hill", "Tufnell Park", "Turnham Green", "Turnpike Lane",
                       "Upminster", "Upminster Bridge", "Upney", "Upton Park", "Uxbridge", "Vauxhall", "Victoria",
                       "Walthamstow Central", "Wanstead", "Wapping", "Warren Street", "Warwick Avenue", "Waterloo",
                       "Watford", "Wembley Central", "Wembley Park", "West Acton", "West Brompton",
                       "West Finchley", "West Ham", "West Hampstead", "West Harrow", "West India Quay",
                       "West Kensington", "West Ruislip", "Westbourne Park", "Westferry", "Westminster",
                       "White City", "Whitechapel", "Willesden Green", "Willesden Junction", "Wimbledon",
                       "Wimbledon Park", "Wood Green", "Woodford", "Woodside Park"]
    
    
    
    
    //all stations as nodes
    
    let ActonTown = MyNode(name: "Acton Town")
    let Aldgate = MyNode(name: "Aldgate")
    let AldgateEast = MyNode(name: "Aldgate East")
    let AllSaints = MyNode(name: "All Saints")
    let Alperton = MyNode(name: "Alperton")
    let Amersham = MyNode(name: "Amersham")
    let Angel = MyNode(name: "Angel")
    let Archway = MyNode(name: "Archway")
    let ArnosGrove = MyNode(name: "Arnos Grove")
    let Arsenal = MyNode(name: "Arsenal")
    
    let BakerStreet = MyNode(name: "Baker Street")
    let Balham = MyNode(name: "Balham")
    let Bank = MyNode(name: "Bank")
    let Barbican = MyNode(name: "Barbican")
    let Barking = MyNode(name: "Barking")
    let Barkingside = MyNode(name: "Barkingside")
    let BaronsCourt = MyNode(name: "Barons Court")
    let Bayswater = MyNode(name: "Bayswater")
    let Beckton = MyNode(name: "Beckton")
    let BecktonPark = MyNode(name: "Beckton Park")
    let Becontree = MyNode(name: "Becontree")
    let BelsizePark = MyNode(name: "Belsize Park")
    let Bermondsey = MyNode(name: "Bermondsey")
    let BethnalGreen = MyNode(name: "Bethnal Green")
    let Blackfriars = MyNode(name: "Blackfriars")
    let BlackhorseRoad = MyNode(name: "Blackhorse Road")
    let Blackwall = MyNode(name: "Blackwall")
    let BondStreet = MyNode(name: "Bond Street")
    let Borough = MyNode(name: "Borough")
    let BostonManor = MyNode(name: "Boston Manor")
    let BoundsGreen = MyNode(name: "Bounds Green")
    let BowChurch = MyNode(name: "Bow Church")
    let BowRoad = MyNode(name: "Bow Road")
    let BrentCross = MyNode(name: "Brent Cross")
    let Brixton = MyNode(name: "Brixton")
    let BromleyByBow = MyNode(name: "Bromley-By-Bow")
    let BuckhurstHill = MyNode(name: "Buckhurst Hill")
    let BurntOak = MyNode(name: "Burnt Oak")
    
    let CaledonianRoad = MyNode(name: "Caledonian Road")
    let CamdenTown = MyNode(name: "Camden Town")
    let CanadaWater = MyNode(name: "Canada Water")
    let CanaryWharf = MyNode(name: "Canary Wharf")
    let CanningTown = MyNode(name: "Canning Town")
    let CannonStreet = MyNode(name: "Cannon Street")
    let CanonsPark = MyNode(name: "Canons Park")
    let ChalfrontAndLatimer = MyNode(name: "Chalfront & Latimer")
    let ChalkFarm = MyNode(name: "Chalk Farm")
    let ChanceryLane = MyNode(name: "Chancery Lane")
    let CharingCross = MyNode(name: "Charing Cross")
    let Chesham = MyNode(name: "Chesham")
    let Chigwell = MyNode(name: "Chigwell")
    let ChiswickPark = MyNode(name: "Chiswick Park")
    let Chorleywood = MyNode(name: "Chorleywood")
    let ClaphamCommon = MyNode(name: "Clapham Common")
    let ClaphamNorth = MyNode(name: "Clapham North")
    let ClaphamSouth = MyNode(name: "Clapham South")
    let Cockfosters = MyNode(name: "Cockfosters")
    let Colindale = MyNode(name: "Colindale")
    let ColliersWood = MyNode(name: "Colliers Wood")
    let CoventGarden = MyNode(name: "Covent Garden")
    let CrossharbourAndLondonArena = MyNode(name: "Crossharbour & London Arena")
    let Croxley = MyNode(name: "Croxley")
    let CustomHouse = MyNode(name: "Custom House")
    let CuttySark = MyNode(name: "Cutty Sark")
    let Cyprus = MyNode(name: "Cyprus")
    
    let DagenhamEast = MyNode(name: "Dagenham East")
    let DagenhamHeathway = MyNode(name: "Dagenham Heathway")
    let Debden = MyNode(name: "Debden")
    let DeptfordBridge = MyNode(name: "Deptford Bridge")
    let DevonsRoad = MyNode(name: "Devons Road")
    let DollisHill = MyNode(name: "Dollis Hill")
    
    let EalingBroadway = MyNode(name: "Ealing Broadway")
    let EalingCommon = MyNode(name: "Ealing Common")
    let EarlsCourt = MyNode(name: "Earl's Court")
    let EastActon = MyNode(name: "East Acton")
    let EastFinchley = MyNode(name: "East Finchley")
    let EastHam = MyNode(name: "East Ham")
    let EastIndia = MyNode(name: "East India")
    let EastPutney = MyNode(name: "East Putney")
    let Eastcote = MyNode(name: "Eastcote")
    let Edgware = MyNode(name: "Edgware")
    let EdgwareRoad = MyNode(name: "Edgware Road")
    let ElephantAndCastle = MyNode(name: "Elephant & Castle")
    let ElmPark = MyNode(name: "Elm Park")
    let ElversonRoad = MyNode(name: "Elverson Road")
    let Embankment = MyNode(name: "Embankment")
    let Epping = MyNode(name: "Epping")
    let Euston = MyNode(name: "Euston")
    let EustonSquare = MyNode(name: "Euston Square")
    
    let Fairlop = MyNode(name: "Fairlop")
    let Farringdon = MyNode(name: "Farringdon")
    let FinchleyCentral = MyNode(name: "Finchley Central")
    let FinchleyRoad = MyNode(name: "Finchley Road")
    let FinsburyPark = MyNode(name: "Finsbury Park")
    let FulhamBroadway = MyNode(name: "Fulham Broadway")
    
    let GallionsReach = MyNode(name: "Gallions Reach")
    let GantsHill = MyNode(name: "Gants Hill")
    let GloucesterRoad = MyNode(name: "Gloucester Road")
    let GoldersGreen = MyNode(name: "Golders Green")
    let GoldhawkRoad = MyNode(name: "Goldhawk Road")
    let GoodgeStreet = MyNode(name: "Goodge Street")
    let GrangeHill = MyNode(name: "Grange Hill")
    let GreatPortlandStreet = MyNode(name: "Great Portland Street")
    let GreenPark = MyNode(name: "Green Park")
    let Greenford = MyNode(name: "Greenford")
    let Greenwich = MyNode(name: "Greenwich")
    let Gunnersbury = MyNode(name: "Gunnersbury")
    
    let Hainault = MyNode(name: "Hainault")
    let Hammersmith = MyNode(name: "Hammersmith")
    let Hampstead = MyNode(name: "Hampstead")
    let HangerLane = MyNode(name: "Hanger Lane")
    let Harlesden = MyNode(name: "Harlesden")
    let HarrowAndWealdston = MyNode(name: "Harrow & Wealston")
    let HarrowOnTheHill = MyNode(name: "Harrow-On-The-Hill")
    let HattonCross = MyNode(name: "Hatton Cross")
    let HeathrowTerminal4 = MyNode(name: "Heathrow Terminal 4")
    let HeathrowTerminal123 = MyNode(name: "Heathrow Terminal 1, 2 & 3")
    let HeathrowTerminal5 = MyNode(name: "Heathrow Terminal 5")
    let HendonCentral = MyNode(name: "Hendon Central")
    let HeronQuays = MyNode(name: "Heron Quays")
    let HighBarnet = MyNode(name: "High Barnet")
    let HighStreetKensington = MyNode(name: "High Street Kensington")
    let HighburyAndIslington = MyNode(name: "Highbury & Islington")
    let Highgate = MyNode(name: "Highgate")
    let Hillingdon = MyNode(name: "Hillingdon")
    let Holborn = MyNode(name: "Holborn")
    let HollandPark = MyNode(name: "Holland Park")
    let HollowayRoad = MyNode(name: "Holloway Road")
    let Hornchurch = MyNode(name: "Hornchurch")
    let HounslowCentral = MyNode(name: "Hounslow Central")
    let HounslowEast = MyNode(name: "Hounslow East")
    let HounslowWest = MyNode(name: "Hounslow West")
    let HydeParkCorner = MyNode(name: "Hyde Park Corner")
    
    let Ickenham = MyNode(name: "Ickenham")
    let IslandGardens = MyNode(name: "Island Gardens")
    
    let Kennington = MyNode(name: "Kennington")
    let KensalGreen = MyNode(name: "Kensal Green")
    let KensintonOlympia = MyNode(name: "Kensinton (Olympia)")
    let KentishTown = MyNode(name: "Kentish Town")
    let Kenton = MyNode(name: "Kenton")
    let KewGardens = MyNode(name: "Kew Gardens")
    let Kilburn = MyNode(name: "Kilburn")
    let KilburnPark = MyNode(name: "Kilburn Park")
    let KingsCross = MyNode(name: "King's Cross St. Pancras")
    let Kingsbury = MyNode(name: "Kingsbury")
    let Knightsbridge = MyNode(name: "Knightsbridge")
    
    let LadbrokeGrove = MyNode(name: "Ladbroke Grove")
    let LambethNorth = MyNode(name: "Lambeth North")
    let LancasterGate = MyNode(name: "Lancaster Gate")
    let LatimerRoad = MyNode(name: "Latimer Road")
    let LeicesterSquare = MyNode(name: "Leicester Square")
    let Lewisham = MyNode(name: "Lewisham")
    let Leyton = MyNode(name: "Leyton")
    let Leytonstone = MyNode(name: "Leytonstone")
    let Limehouse = MyNode(name: "Limehouse")
    let LiverpoolStreet = MyNode(name: "Liverpool Street")
    let LondonBridge = MyNode(name: "London Bridge")
    let Loughton = MyNode(name: "Loughton")
    
    let MaidaVale = MyNode(name: "Maida Vale")
    let ManorHouse = MyNode(name: "Manor House")
    let MansionHouse = MyNode(name: "Mansion House")
    let MarbleArch = MyNode(name: "Marble Arch")
    let Marylebone = MyNode(name: "Marylebone")
    let MileEnd = MyNode(name: "Mile End")
    let MillHillEast = MyNode(name: "Mill Hill East")
    let Monument = MyNode(name: "Monument")
    let MoorPark = MyNode(name: "Moor Park")
    let Moorgate = MyNode(name: "Moorgate")
    let Morden = MyNode(name: "Morden")
    let MorningtonCresent = MyNode(name: "Mornington Cresent")
    let Mudchute = MyNode(name: "Mudchute")
    
    let Neasden = MyNode(name: "Neasden")
    let NewCross = MyNode(name: "New Cross")
    let NewCrossGate = MyNode(name: "New Cross Gate")
    let NewburyPark = MyNode(name: "Newbury Park")
    let NorthActon = MyNode(name: "North Acton")
    let NorthEaling = MyNode(name: "North Ealing")
    let NorthGreenwich = MyNode(name: "North Greenwich")
    let NorthHarrow = MyNode(name: "North Harrow")
    let NorthWembley = MyNode(name: "North Wembley")
    let Northfields = MyNode(name: "Northfields")
    let Northolt = MyNode(name: "Northolt")
    let NorthwickPark = MyNode(name: "Northwick Park")
    let Northwood = MyNode(name: "Northwood")
    let NorthwoodHills = MyNode(name: "Northwood Hills")
    let NottingHillGate = MyNode(name: "Notting Hill Gate")
    
    let Oakwood = MyNode(name: "Oakwood")
    let OldStreet = MyNode(name: "Old Street")
    let Osterley = MyNode(name: "Osterley")
    let Oval = MyNode(name: "Oval")
    let OxfordCircus = MyNode(name: "Oxford Circus")
    
    let Paddington = MyNode(name: "Paddington")
    let ParkRoyal = MyNode(name: "Park Royal")
    let ParsonsGreen = MyNode(name: "Parsons Green")
    let Perivale = MyNode(name: "Perivale")
    let PicadillyCircus = MyNode(name: "Picadilly Circus")
    let Pimlico = MyNode(name: "Pimlico")
    let Pinner = MyNode(name: "Pinner")
    let Plaistow = MyNode(name: "Plaistow")
    let Poplar = MyNode(name: "Poplar")
    let PrestonRoad = MyNode(name: "Preston Road")
    let PrinceRegent = MyNode(name: "Prince Regent")
    let PuddingMillLane = MyNode(name: "Pudding Mill Lane")
    let PutneyBridge = MyNode(name: "Putney Bridge")
    
    let QueensPark = MyNode(name: "Queen's Park")
    let Queensbury = MyNode(name: "Queensbury")
    let Queensway = MyNode(name: "Queensway")
    
    let RavenscourtPark = MyNode(name: "Ravenscourt Park")
    let RaynersLane = MyNode(name: "Rayners Lane")
    let Redbridge = MyNode(name: "Redbridge")
    let RegentsPark = MyNode(name: "Regents Park")
    let Richmond = MyNode(name: "Richmond")
    let Rickmansworth = MyNode(name: "Rickmansworth")
    let RodingValley = MyNode(name: "Roding Valley")
    let Rotherhithe = MyNode(name: "Rotherhithe")
    let RoyalAlbert = MyNode(name: "Royal Albert")
    let RoyalOak = MyNode(name: "Royal Oak")
    let RoyalVictoria = MyNode(name: "Royal Victoria")
    let Ruislip = MyNode(name: "Ruislip")
    let RuislipGardens = MyNode(name: "Ruislip Gardens")
    let RuislipManor = MyNode(name: "Ruislip Manor")
    let RussellSquare = MyNode(name: "Russel Square")
    
    let SevenSisters = MyNode(name: "Seven Sisters")
    let Shadwell = MyNode(name: "Shadwell")
    let ShephardsBush = MyNode(name: "Shephards Bush")
    let Shoreditch = MyNode(name: "Shoreditch")
    let SloaneSquare = MyNode(name: "Sloane Square")
    let Snaresbrook = MyNode(name: "Snaresbrook")
    let SouthEaling = MyNode(name: "South Ealing")
    let SouthHarrow = MyNode(name: "South Harrow")
    let SouthKensington = MyNode(name: "South Kensington")
    let SouthKenton = MyNode(name: "South Kenton")
    let SouthQuays = MyNode(name: "South Quays")
    let SouthRuislip = MyNode(name: "South Ruislip")
    let SouthWimbledon = MyNode(name: "South Wimbledon")
    let SouthWoodford = MyNode(name: "South Woodford")
    let Southfields = MyNode(name: "Southfields")
    let Southgate = MyNode(name: "Southgate")
    let Southwark = MyNode(name: "Southwark")
    let StJamesPark = MyNode(name: "St. Jame's Park")
    let StJohnsWood = MyNode(name: "St. John's Wood")
    let StPauls = MyNode(name: "St. Paul's")
    let StamfordBrook = MyNode(name: "Stamford Brook")
    let Stanmore = MyNode(name: "Stanmore")
    let StephneyGreen = MyNode(name: "Stephney Green")
    let Stockwell = MyNode(name: "Stockwell")
    let StonebridgePark = MyNode(name: "Stonebridge Park")
    let Stratford = MyNode(name: "Stratford")
    let SudburyHill = MyNode(name: "Sudbury Hill")
    let SudburyTown = MyNode(name: "Sudbury Town")
    let SurreyQuays = MyNode(name: "Surrey Quays")
    let SwissCottage = MyNode(name: "Swiss Cottage")
    
    let Temple = MyNode(name: "Temple")
    let TheydonBois = MyNode(name: "Theydon Bois")
    let TootingBec = MyNode(name: "Tooting Bec")
    let TootingBroadway = MyNode(name: "Tooting Broadway")
    let TottenhamCourtRoad = MyNode(name: "Tottenham Court Road")
    let TottenhamHale = MyNode(name: "Tottenham Hale")
    let TotteridgeAndWhetstone = MyNode(name: "Totteridge & Whetstone")
    let TowerGateway = MyNode(name: "Tower Gateway")
    let TowerHill = MyNode(name: "Tower Hill")
    let TufnellPark = MyNode(name: "Tufnell Park")
    let TurnhamGreen = MyNode(name: "Turnham Green")
    let TurnpikeLane = MyNode(name: "Turnpike Lane")
    
    let Upminster = MyNode(name: "Upminster")
    let UpminsterBridge = MyNode(name: "Upminster Bridge")
    let Upney = MyNode(name: "Upney")
    let UptonPark = MyNode(name: "Upton Park")
    let Uxbridge = MyNode(name: "Uxbridge")
    
    let Vauxhall = MyNode(name: "Vauxhall")
    let Victoria = MyNode(name: "Victoria")
    
    let WalthamstowCentral = MyNode(name: "Walthamstow Central")
    let Wanstead = MyNode(name: "Wanstead")
    let Wapping = MyNode(name: "Wapping")
    let WarrenStreet = MyNode(name: "Warren Street")
    let WarwickAvenue = MyNode(name: "Warwick Avenue")
    let Waterloo = MyNode(name: "Waterloo")
    let Watford = MyNode(name: "Watford")
    let WembleyCentral = MyNode(name: "Wembley Central")
    let WembleyPark = MyNode(name: "Wembley Park")
    let WestActon = MyNode(name: "West Acton")
    let WestBrompton = MyNode(name: "West Brompton")
    let WestFinchley = MyNode(name: "West Finchley")
    let WestHam = MyNode(name: "West Ham")
    let WestHampstead = MyNode(name: "West Hampstead")
    let WestHarrow = MyNode(name: "West Harrow")
    let WestIndiaQuay = MyNode(name: "West India Quay")
    let WestKensington = MyNode(name: "West Kensington")
    let WestRuislip = MyNode(name: "West Ruislip")
    let WestbournePark = MyNode(name: "Westbourne Park")
    let Westferry = MyNode(name: "Westferry")
    let Westminster = MyNode(name: "Westminster")
    let WhiteCity = MyNode(name: "White City")
    let Whitechapel = MyNode(name: "Whitechapel")
    let WillesdenGreen = MyNode(name: "Willesden Green")
    let WillesdenJunction = MyNode(name: "Willesden Junction")
    let Wimbledon = MyNode(name: "Wimbledon")
    let WimbledonPark = MyNode(name: "Wimbledon Park")
    let WoodGreen = MyNode(name: "Wood Green")
    let Woodford = MyNode(name: "Woodford")
    let WoodsidePark = MyNode(name: "Woodside Park")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.HideKeyboard()
        
        createTubeConnections()
        
        fromPickeview.dataSource = self
        fromPickeview.delegate = self
        
        toPickerview.dataSource = self
        toPickerview.delegate = self
        
    }
    
    
    
    
    func shortestPath(source: Node, destination: Node) -> Path? {
        var frontier: [Path] = [] {
            didSet { frontier.sort { return $0.cumulativeWeight < $1.cumulativeWeight } } // the frontier has to be always ordered
        }
        
        frontier.append(Path(to: source)) // the frontier is made by a path that starts nowhere and ends in the source
        
        while !frontier.isEmpty {
            let cheapestPathInFrontier = frontier.removeFirst() // getting the cheapest path available
            guard !cheapestPathInFrontier.node.visited else { continue } // making sure we haven't visited the node already
            
            if cheapestPathInFrontier.node === destination {
                return cheapestPathInFrontier // found the cheapest path
            }
            
            cheapestPathInFrontier.node.visited = true
            
            for connection in cheapestPathInFrontier.node.stations where !connection.to.visited { // adding new paths to our frontier
                frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
            }
        } // end while
        return nil // we didn't find a path
    }
    
    
    @IBAction func findJourney(_ sender: Any) {
        
        checkNode()
        
        var journey = String()
        let path = shortestPath(source: sourceNode, destination: destinationNode)
        
        if let succession: [String] = path?.array.reversed().compactMap({ $0 as? MyNode}).map({$0.name}) {
            
            //how to show path in text area
            journey = succession.joined(separator: ", ")
            
            journeyText.text = "🏁 Quickest path: \(journey)"
            
        } else {
            
            journeyText.text = "💥 No path between \(sourceNode.name) & \(destinationNode.name)"
            
        }
        
        journeyButton.isHidden = true
        
    }
    
    
    func createTubeConnections() {
        
        ActonTown.stations.append(Station(to: EalingCommon, weight: 1))
        ActonTown.stations.append(Station(to: SouthEaling, weight: 1))
        ActonTown.stations.append(Station(to: TurnhamGreen, weight: 1))
        ActonTown.stations.append(Station(to: ChiswickPark, weight: 1))
        Aldgate.stations.append(Station(to: LiverpoolStreet, weight: 1))
        Aldgate.stations.append(Station(to: TowerHill, weight: 1))
        AldgateEast.stations.append(Station(to: TowerHill, weight: 1))
        AldgateEast.stations.append(Station(to: Whitechapel, weight: 1))
        AldgateEast.stations.append(Station(to: LiverpoolStreet, weight: 1))
        AllSaints.stations.append(Station(to: DevonsRoad, weight: 1))
        AllSaints.stations.append(Station(to: Poplar, weight: 1))
        Alperton.stations.append(Station(to: ParkRoyal, weight: 1))
        Alperton.stations.append(Station(to: SudburyTown, weight: 1))
        Amersham.stations.append(Station(to: ChalfrontAndLatimer, weight: 1))
        Angel.stations.append(Station(to: KingsCross, weight: 1))
        Angel.stations.append(Station(to: OldStreet, weight: 1))
        Archway.stations.append(Station(to: Highgate, weight: 1))
        Archway.stations.append(Station(to: TufnellPark, weight: 1))
        ArnosGrove.stations.append(Station(to: BoundsGreen, weight: 1))
        ArnosGrove.stations.append(Station(to: Southgate, weight: 1))
        Arsenal.stations.append(Station(to: FinsburyPark, weight: 1))
        Arsenal.stations.append(Station(to: HollowayRoad, weight: 1))
        BakerStreet.stations.append(Station(to: Marylebone, weight: 1))
        BakerStreet.stations.append(Station(to: RegentsPark, weight: 1))
        BakerStreet.stations.append(Station(to: GreatPortlandStreet, weight: 1))
        BakerStreet.stations.append(Station(to: BondStreet, weight: 1))
        BakerStreet.stations.append(Station(to: StJohnsWood, weight: 1))
        BakerStreet.stations.append(Station(to: FinchleyRoad, weight: 1))
        Balham.stations.append(Station(to: ClaphamSouth, weight: 1))
        Balham.stations.append(Station(to: TootingBec, weight: 1))
        Bank.stations.append(Station(to: LiverpoolStreet, weight: 1))
        Bank.stations.append(Station(to: StPauls, weight: 1))
        Bank.stations.append(Station(to: Shadwell, weight: 1))
        Bank.stations.append(Station(to: LondonBridge, weight: 1))
        Bank.stations.append(Station(to: Moorgate, weight: 1))
        Bank.stations.append(Station(to: Waterloo, weight: 1))
        Barbican.stations.append(Station(to: Farringdon, weight: 1))
        Barbican.stations.append(Station(to: Moorgate, weight: 1))
        Barking.stations.append(Station(to: EastHam, weight: 1))
        Barking.stations.append(Station(to: Upney, weight: 1))
        Barkingside.stations.append(Station(to: Fairlop, weight: 1))
        Barkingside.stations.append(Station(to: NewburyPark, weight: 1))
        BaronsCourt.stations.append(Station(to: Hammersmith, weight: 1))
        BaronsCourt.stations.append(Station(to: WestKensington, weight: 1))
        BaronsCourt.stations.append(Station(to: EarlsCourt, weight: 1))
        Bayswater.stations.append(Station(to: NottingHillGate, weight: 1))
        Bayswater.stations.append(Station(to: Paddington, weight: 1))
        Beckton.stations.append(Station(to: GallionsReach, weight: 1))
        BecktonPark.stations.append(Station(to: Cyprus, weight: 1))
        BecktonPark.stations.append(Station(to: RoyalAlbert, weight: 1))
        Becontree.stations.append(Station(to: DagenhamHeathway, weight: 1))
        Becontree.stations.append(Station(to: Upney, weight: 1))
        BelsizePark.stations.append(Station(to: ChalkFarm, weight: 1))
        BelsizePark.stations.append(Station(to: Hampstead, weight: 1))
        Bermondsey.stations.append(Station(to: CanadaWater, weight: 1))
        Bermondsey.stations.append(Station(to: LondonBridge, weight: 1))
        BethnalGreen.stations.append(Station(to: LiverpoolStreet, weight: 1))
        BethnalGreen.stations.append(Station(to: MileEnd, weight: 1))
        Blackfriars.stations.append(Station(to: MansionHouse, weight: 1))
        Blackfriars.stations.append(Station(to: Temple, weight: 1))
        BlackhorseRoad.stations.append(Station(to: TottenhamHale, weight: 1))
        BlackhorseRoad.stations.append(Station(to: WalthamstowCentral, weight: 1))
        Blackwall.stations.append(Station(to: EastIndia, weight: 1))
        Blackwall.stations.append(Station(to: Poplar, weight: 1))
        BondStreet.stations.append(Station(to: MarbleArch, weight: 1))
        BondStreet.stations.append(Station(to: OxfordCircus, weight: 1))
        BondStreet.stations.append(Station(to: GreenPark, weight: 1))
        BondStreet.stations.append(Station(to: BakerStreet, weight: 1))
        Borough.stations.append(Station(to: ElephantAndCastle, weight: 1))
        Borough.stations.append(Station(to: LondonBridge, weight: 1))
        BostonManor.stations.append(Station(to: Northfields, weight: 1))
        BostonManor.stations.append(Station(to: Osterley, weight: 1))
        BoundsGreen.stations.append(Station(to: WoodGreen, weight: 1))
        BoundsGreen.stations.append(Station(to: ArnosGrove, weight: 1))
        BowChurch.stations.append(Station(to: DevonsRoad, weight: 1))
        BowChurch.stations.append(Station(to: PuddingMillLane, weight: 1))
        BowRoad.stations.append(Station(to: BromleyByBow, weight: 1))
        BowRoad.stations.append(Station(to: MileEnd, weight: 1))
        BrentCross.stations.append(Station(to: GoldersGreen, weight: 1))
        BrentCross.stations.append(Station(to: HendonCentral, weight: 1))
        Brixton.stations.append(Station(to: Stockwell, weight: 1))
        BromleyByBow.stations.append(Station(to: WestHam, weight: 1))
        BromleyByBow.stations.append(Station(to: BowRoad, weight: 1))
        BuckhurstHill.stations.append(Station(to: Loughton, weight: 1))
        BuckhurstHill.stations.append(Station(to: Woodford, weight: 1))
        BurntOak.stations.append(Station(to: Colindale, weight: 1))
        BurntOak.stations.append(Station(to: Edgware, weight: 1))
        CaledonianRoad.stations.append(Station(to: HollowayRoad, weight: 1))
        CaledonianRoad.stations.append(Station(to: KingsCross, weight: 1))
        CamdenTown.stations.append(Station(to: ChalkFarm, weight: 1))
        CamdenTown.stations.append(Station(to: Euston, weight: 1))
        CamdenTown.stations.append(Station(to: KentishTown, weight: 1))
        CamdenTown.stations.append(Station(to: MorningtonCresent, weight: 1))
        CanadaWater.stations.append(Station(to: Rotherhithe, weight: 1))
        CanadaWater.stations.append(Station(to: SurreyQuays, weight: 1))
        CanadaWater.stations.append(Station(to: CanaryWharf, weight: 1))
        CanadaWater.stations.append(Station(to: Bermondsey, weight: 1))
        CanaryWharf.stations.append(Station(to: HeronQuays, weight: 1))
        CanaryWharf.stations.append(Station(to: WestIndiaQuay, weight: 1))
        CanaryWharf.stations.append(Station(to: NorthGreenwich, weight: 1))
        CanaryWharf.stations.append(Station(to: CanadaWater, weight: 1))
        CanningTown.stations.append(Station(to: EastIndia, weight: 1))
        CanningTown.stations.append(Station(to: RoyalVictoria, weight: 1))
        CanningTown.stations.append(Station(to: NorthGreenwich, weight: 1))
        CanningTown.stations.append(Station(to: WestHam, weight: 1))
        CannonStreet.stations.append(Station(to: MansionHouse, weight: 1))
        CannonStreet.stations.append(Station(to: Monument, weight: 1))
        CanonsPark.stations.append(Station(to: Queensbury, weight: 1))
        CanonsPark.stations.append(Station(to: Stanmore, weight: 1))
        ChalfrontAndLatimer.stations.append(Station(to: Chesham, weight: 1))
        ChalfrontAndLatimer.stations.append(Station(to: Chorleywood, weight: 1))
        ChalfrontAndLatimer.stations.append(Station(to: Amersham, weight: 1))
        ChalkFarm.stations.append(Station(to: BelsizePark, weight: 1))
        ChalkFarm.stations.append(Station(to: CamdenTown, weight: 1))
        ChanceryLane.stations.append(Station(to: Holborn, weight: 1))
        ChanceryLane.stations.append(Station(to: StPauls, weight: 1))
        CharingCross.stations.append(Station(to: Embankment, weight: 1))
        CharingCross.stations.append(Station(to: PicadillyCircus, weight: 1))
        CharingCross.stations.append(Station(to: LeicesterSquare, weight: 1))
        Chesham.stations.append(Station(to: ChalfrontAndLatimer, weight: 1))
        Chigwell.stations.append(Station(to: GrangeHill, weight: 1))
        Chigwell.stations.append(Station(to: RodingValley, weight: 1))
        ChiswickPark.stations.append(Station(to: ActonTown, weight: 1))
        ChiswickPark.stations.append(Station(to: TurnhamGreen, weight: 1))
        Chorleywood.stations.append(Station(to: Rickmansworth, weight: 1))
        Chorleywood.stations.append(Station(to: ChalfrontAndLatimer, weight: 1))
        ClaphamCommon.stations.append(Station(to: ClaphamNorth, weight: 1))
        ClaphamCommon.stations.append(Station(to: ClaphamSouth, weight: 1))
        ClaphamNorth.stations.append(Station(to: Stockwell, weight: 1))
        ClaphamNorth.stations.append(Station(to: ClaphamCommon, weight: 1))
        ClaphamSouth.stations.append(Station(to: Balham, weight: 1))
        ClaphamSouth.stations.append(Station(to: ClaphamCommon, weight: 1))
        Cockfosters.stations.append(Station(to: Oakwood, weight: 1))
        Colindale.stations.append(Station(to: HendonCentral, weight: 1))
        Colindale.stations.append(Station(to: BurntOak, weight: 1))
        ColliersWood.stations.append(Station(to: SouthWimbledon, weight: 1))
        ColliersWood.stations.append(Station(to: TootingBroadway, weight: 1))
        CoventGarden.stations.append(Station(to: Holborn, weight: 1))
        CoventGarden.stations.append(Station(to: LeicesterSquare, weight: 1))
        CrossharbourAndLondonArena.stations.append(Station(to: Mudchute, weight: 1))
        CrossharbourAndLondonArena.stations.append(Station(to: SouthQuays, weight: 1))
        Croxley.stations.append(Station(to: MoorPark, weight: 1))
        Croxley.stations.append(Station(to: Watford, weight: 1))
        CustomHouse.stations.append(Station(to: PrinceRegent, weight: 1))
        CustomHouse.stations.append(Station(to: RoyalVictoria, weight: 1))
        CuttySark.stations.append(Station(to: Greenwich, weight: 1))
        CuttySark.stations.append(Station(to: IslandGardens, weight: 1))
        Cyprus.stations.append(Station(to: GallionsReach, weight: 1))
        Cyprus.stations.append(Station(to: BecktonPark, weight: 1))
        DagenhamEast.stations.append(Station(to: DagenhamHeathway, weight: 1))
        DagenhamEast.stations.append(Station(to: ElmPark, weight: 1))
        DagenhamHeathway.stations.append(Station(to: Becontree, weight: 1))
        DagenhamHeathway.stations.append(Station(to: DagenhamEast, weight: 1))
        Debden.stations.append(Station(to: Loughton, weight: 1))
        Debden.stations.append(Station(to: TheydonBois, weight: 1))
        DeptfordBridge.stations.append(Station(to: ElversonRoad, weight: 1))
        DeptfordBridge.stations.append(Station(to: Greenwich, weight: 1))
        DevonsRoad.stations.append(Station(to: AllSaints, weight: 1))
        DevonsRoad.stations.append(Station(to: BowChurch, weight: 1))
        DollisHill.stations.append(Station(to: Neasden, weight: 1))
        DollisHill.stations.append(Station(to: WillesdenGreen, weight: 1))
        EalingBroadway.stations.append(Station(to: WestActon, weight: 1))
        EalingBroadway.stations.append(Station(to: EalingCommon, weight: 1))
        EalingCommon.stations.append(Station(to: ActonTown, weight: 1))
        EalingCommon.stations.append(Station(to: NorthEaling, weight: 1))
        EalingCommon.stations.append(Station(to: EalingBroadway, weight: 1))
        EarlsCourt.stations.append(Station(to: GloucesterRoad, weight: 1))
        EarlsCourt.stations.append(Station(to: HighStreetKensington, weight: 1))
        EarlsCourt.stations.append(Station(to: KensintonOlympia, weight: 1))
        EarlsCourt.stations.append(Station(to: WestBrompton, weight: 1))
        EarlsCourt.stations.append(Station(to: WestKensington, weight: 1))
        EarlsCourt.stations.append(Station(to: BaronsCourt, weight: 1))
        EastActon.stations.append(Station(to: NorthActon, weight: 1))
        EastActon.stations.append(Station(to: WhiteCity, weight: 1))
        EastFinchley.stations.append(Station(to: FinchleyCentral, weight: 1))
        EastFinchley.stations.append(Station(to: Highgate, weight: 1))
        EastHam.stations.append(Station(to: UptonPark, weight: 1))
        EastHam.stations.append(Station(to: Barking, weight: 1))
        EastIndia.stations.append(Station(to: Blackwall, weight: 1))
        EastIndia.stations.append(Station(to: CanningTown, weight: 1))
        EastPutney.stations.append(Station(to: PutneyBridge, weight: 1))
        EastPutney.stations.append(Station(to: Southfields, weight: 1))
        Eastcote.stations.append(Station(to: RaynersLane, weight: 1))
        Eastcote.stations.append(Station(to: RuislipManor, weight: 1))
        Edgware.stations.append(Station(to: BurntOak, weight: 1))
        EdgwareRoad.stations.append(Station(to: Marylebone, weight: 1))
        EdgwareRoad.stations.append(Station(to: Paddington, weight: 1))
        EdgwareRoad.stations.append(Station(to: BakerStreet, weight: 1))
        ElephantAndCastle.stations.append(Station(to: LambethNorth, weight: 1))
        ElephantAndCastle.stations.append(Station(to: Kennington, weight: 1))
        ElephantAndCastle.stations.append(Station(to: Borough, weight: 1))
        ElmPark.stations.append(Station(to: Hornchurch, weight: 1))
        ElmPark.stations.append(Station(to: DagenhamEast, weight: 1))
        ElversonRoad.stations.append(Station(to: Lewisham, weight: 1))
        ElversonRoad.stations.append(Station(to: DeptfordBridge, weight: 1))
        Embankment.stations.append(Station(to: Waterloo, weight: 1))
        Embankment.stations.append(Station(to: Temple, weight: 1))
        Embankment.stations.append(Station(to: Westminster, weight: 1))
        Embankment.stations.append(Station(to: CharingCross, weight: 1))
        Epping.stations.append(Station(to: TheydonBois, weight: 1))
        Euston.stations.append(Station(to: KingsCross, weight: 1))
        Euston.stations.append(Station(to: MorningtonCresent, weight: 1))
        Euston.stations.append(Station(to: WarrenStreet, weight: 1))
        Euston.stations.append(Station(to: CamdenTown, weight: 1))
        EustonSquare.stations.append(Station(to: GreatPortlandStreet, weight: 1))
        EustonSquare.stations.append(Station(to: KingsCross, weight: 1))
        Fairlop.stations.append(Station(to: Hainault, weight: 1))
        Fairlop.stations.append(Station(to: Barkingside, weight: 1))
        Farringdon.stations.append(Station(to: KingsCross, weight: 1))
        Farringdon.stations.append(Station(to: Barbican, weight: 1))
        FinchleyCentral.stations.append(Station(to: MillHillEast, weight: 1))
        FinchleyCentral.stations.append(Station(to: WestFinchley, weight: 1))
        FinchleyCentral.stations.append(Station(to: EastFinchley, weight: 1))
        FinchleyRoad.stations.append(Station(to: SwissCottage, weight: 1))
        FinchleyRoad.stations.append(Station(to: WestHampstead, weight: 1))
        FinchleyRoad.stations.append(Station(to: WembleyPark, weight: 1))
        FinchleyRoad.stations.append(Station(to: BakerStreet, weight: 1))
        FinsburyPark.stations.append(Station(to: ManorHouse, weight: 1))
        FinsburyPark.stations.append(Station(to: HighburyAndIslington, weight: 1))
        FinsburyPark.stations.append(Station(to: SevenSisters, weight: 1))
        FinsburyPark.stations.append(Station(to: Arsenal, weight: 1))
        FulhamBroadway.stations.append(Station(to: ParsonsGreen, weight: 1))
        FulhamBroadway.stations.append(Station(to: WestBrompton, weight: 1))
        GallionsReach.stations.append(Station(to: Beckton, weight: 1))
        GloucesterRoad.stations.append(Station(to: HighStreetKensington, weight: 1))
        GloucesterRoad.stations.append(Station(to: SouthKensington, weight: 1))
        GloucesterRoad.stations.append(Station(to: EarlsCourt, weight: 1))
        GoldersGreen.stations.append(Station(to: Hampstead, weight: 1))
        GoldersGreen.stations.append(Station(to: BrentCross, weight: 1))
        GoldhawkRoad.stations.append(Station(to: Hammersmith, weight: 1))
        GoldhawkRoad.stations.append(Station(to: ShephardsBush, weight: 1))
        GoodgeStreet.stations.append(Station(to: TottenhamCourtRoad, weight: 1))
        GoodgeStreet.stations.append(Station(to: WarrenStreet, weight: 1))
        GrangeHill.stations.append(Station(to: Hainault, weight: 1))
        GrangeHill.stations.append(Station(to: Chigwell, weight: 1))
        GreatPortlandStreet.stations.append(Station(to: BakerStreet, weight: 1))
        GreatPortlandStreet.stations.append(Station(to: EustonSquare, weight: 1))
        GreenPark.stations.append(Station(to: Westminster, weight: 1))
        GreenPark.stations.append(Station(to: HydeParkCorner, weight: 1))
        GreenPark.stations.append(Station(to: PicadillyCircus, weight: 1))
        GreenPark.stations.append(Station(to: OxfordCircus, weight: 1))
        GreenPark.stations.append(Station(to: Victoria, weight: 1))
        GreenPark.stations.append(Station(to: BondStreet, weight: 1))
        Greenford.stations.append(Station(to: Northolt, weight: 1))
        Greenford.stations.append(Station(to: Perivale, weight: 1))
        Greenwich.stations.append(Station(to: CuttySark, weight: 1))
        Greenwich.stations.append(Station(to: DeptfordBridge, weight: 1))
        Gunnersbury.stations.append(Station(to: KewGardens, weight: 1))
        Gunnersbury.stations.append(Station(to: TurnhamGreen, weight: 1))
        Hainault.stations.append(Station(to: Fairlop, weight: 1))
        Hainault.stations.append(Station(to: GrangeHill, weight: 1))
        Hammersmith.stations.append(Station(to: RavenscourtPark, weight: 1))
        Hammersmith.stations.append(Station(to: TurnhamGreen, weight: 1))
        Hammersmith.stations.append(Station(to: BaronsCourt, weight: 1))
        Hammersmith.stations.append(Station(to: GoldhawkRoad, weight: 1))
        Hampstead.stations.append(Station(to: BelsizePark, weight: 1))
        Hampstead.stations.append(Station(to: GoldersGreen, weight: 1))
        HangerLane.stations.append(Station(to: NorthActon, weight: 1))
        HangerLane.stations.append(Station(to: Perivale, weight: 1))
        Harlesden.stations.append(Station(to: StonebridgePark, weight: 1))
        Harlesden.stations.append(Station(to: WillesdenJunction, weight: 1))
        HarrowAndWealdston.stations.append(Station(to: Kenton, weight: 1))
        HarrowOnTheHill.stations.append(Station(to: NorthwickPark, weight: 1))
        HarrowOnTheHill.stations.append(Station(to: NorthHarrow, weight: 1))
        HarrowOnTheHill.stations.append(Station(to: WestHarrow, weight: 1))
        HattonCross.stations.append(Station(to: HeathrowTerminal123, weight: 1))
        HattonCross.stations.append(Station(to: HeathrowTerminal4, weight: 1))
        HeathrowTerminal4.stations.append(Station(to: HeathrowTerminal123, weight: 1))
        HeathrowTerminal4.stations.append(Station(to: HeathrowTerminal5, weight: 1))
        HeathrowTerminal4.stations.append(Station(to: HattonCross, weight: 1))
        HeathrowTerminal123.stations.append(Station(to: HeathrowTerminal4, weight: 1))
        HeathrowTerminal123.stations.append(Station(to: HattonCross, weight: 1))
        HeathrowTerminal5.stations.append(Station(to: HeathrowTerminal4, weight: 1))
        HendonCentral.stations.append(Station(to: BrentCross, weight: 1))
        HendonCentral.stations.append(Station(to: Colindale, weight: 1))
        HeronQuays.stations.append(Station(to: SouthQuays, weight: 1))
        HeronQuays.stations.append(Station(to: CanaryWharf, weight: 1))
        HighBarnet.stations.append(Station(to: TotteridgeAndWhetstone, weight: 1))
        HighStreetKensington.stations.append(Station(to: NottingHillGate, weight: 1))
        HighStreetKensington.stations.append(Station(to: EarlsCourt, weight: 1))
        HighStreetKensington.stations.append(Station(to: GloucesterRoad, weight: 1))
        HighburyAndIslington.stations.append(Station(to: KingsCross, weight: 1))
        HighburyAndIslington.stations.append(Station(to: FinsburyPark, weight: 1))
        Highgate.stations.append(Station(to: Archway, weight: 1))
        Highgate.stations.append(Station(to: EastFinchley, weight: 1))
        Hillingdon.stations.append(Station(to: Ickenham, weight: 1))
        Hillingdon.stations.append(Station(to: Uxbridge, weight: 1))
        Holborn.stations.append(Station(to: TottenhamCourtRoad, weight: 1))
        Holborn.stations.append(Station(to: RussellSquare, weight: 1))
        Holborn.stations.append(Station(to: ChanceryLane, weight: 1))
        Holborn.stations.append(Station(to: CoventGarden, weight: 1))
        HollandPark.stations.append(Station(to: NottingHillGate, weight: 1))
        HollandPark.stations.append(Station(to: ShephardsBush, weight: 1))
        HollowayRoad.stations.append(Station(to: Arsenal, weight: 1))
        HollowayRoad.stations.append(Station(to: CaledonianRoad, weight: 1))
        Hornchurch.stations.append(Station(to: UpminsterBridge, weight: 1))
        Hornchurch.stations.append(Station(to: ElmPark, weight: 1))
        HounslowCentral.stations.append(Station(to: HounslowEast, weight: 1))
        HounslowCentral.stations.append(Station(to: HounslowWest, weight: 1))
        HounslowEast.stations.append(Station(to: Osterley, weight: 1))
        HounslowEast.stations.append(Station(to: HounslowCentral, weight: 1))
        HounslowWest.stations.append(Station(to: HattonCross, weight: 1))
        HounslowWest.stations.append(Station(to: HounslowCentral, weight: 1))
        HydeParkCorner.stations.append(Station(to: Knightsbridge, weight: 1))
        HydeParkCorner.stations.append(Station(to: GreenPark, weight: 1))
        Ickenham.stations.append(Station(to: Ruislip, weight: 1))
        Ickenham.stations.append(Station(to: Hillingdon, weight: 1))
        IslandGardens.stations.append(Station(to: Mudchute, weight: 1))
        IslandGardens.stations.append(Station(to: CuttySark, weight: 1))
        Kennington.stations.append(Station(to: Oval, weight: 1))
        Kennington.stations.append(Station(to: Waterloo, weight: 1))
        Kennington.stations.append(Station(to: ElephantAndCastle, weight: 1))
        KensalGreen.stations.append(Station(to: QueensPark, weight: 1))
        KensalGreen.stations.append(Station(to: WillesdenJunction, weight: 1))
        KensintonOlympia.stations.append(Station(to: EarlsCourt, weight: 1))
        KentishTown.stations.append(Station(to: TufnellPark, weight: 1))
        KentishTown.stations.append(Station(to: CamdenTown, weight: 1))
        Kenton.stations.append(Station(to: SouthKenton, weight: 1))
        Kenton.stations.append(Station(to: HarrowAndWealdston, weight: 1))
        KewGardens.stations.append(Station(to: Richmond, weight: 1))
        KewGardens.stations.append(Station(to: Gunnersbury, weight: 1))
        Kilburn.stations.append(Station(to: WestHampstead, weight: 1))
        Kilburn.stations.append(Station(to: WillesdenGreen, weight: 1))
        KilburnPark.stations.append(Station(to: MaidaVale, weight: 1))
        KilburnPark.stations.append(Station(to: QueensPark, weight: 1))
        KingsCross.stations.append(Station(to: RussellSquare, weight: 1))
        KingsCross.stations.append(Station(to: Angel, weight: 1))
        KingsCross.stations.append(Station(to: CaledonianRoad, weight: 1))
        KingsCross.stations.append(Station(to: Euston, weight: 1))
        KingsCross.stations.append(Station(to: EustonSquare, weight: 1))
        KingsCross.stations.append(Station(to: Farringdon, weight: 1))
        KingsCross.stations.append(Station(to: HighburyAndIslington, weight: 1))
        Kingsbury.stations.append(Station(to: Queensbury, weight: 1))
        Kingsbury.stations.append(Station(to: WembleyPark, weight: 1))
        Knightsbridge.stations.append(Station(to: SouthKensington, weight: 1))
        Knightsbridge.stations.append(Station(to: HydeParkCorner, weight: 1))
        LadbrokeGrove.stations.append(Station(to: LatimerRoad, weight: 1))
        LadbrokeGrove.stations.append(Station(to: WestbournePark, weight: 1))
        LambethNorth.stations.append(Station(to: Waterloo, weight: 1))
        LambethNorth.stations.append(Station(to: ElephantAndCastle, weight: 1))
        LancasterGate.stations.append(Station(to: MarbleArch, weight: 1))
        LancasterGate.stations.append(Station(to: Queensway, weight: 1))
        LatimerRoad.stations.append(Station(to: ShephardsBush, weight: 1))
        LatimerRoad.stations.append(Station(to: LadbrokeGrove, weight: 1))
        LeicesterSquare.stations.append(Station(to: TottenhamCourtRoad, weight: 1))
        LeicesterSquare.stations.append(Station(to: PicadillyCircus, weight: 1))
        LeicesterSquare.stations.append(Station(to: CharingCross, weight: 1))
        LeicesterSquare.stations.append(Station(to: CoventGarden, weight: 1))
        Lewisham.stations.append(Station(to: ElversonRoad, weight: 1))
        Leyton.stations.append(Station(to: Leytonstone, weight: 1))
        Leyton.stations.append(Station(to: Stratford, weight: 1))
        Leytonstone.stations.append(Station(to: Snaresbrook, weight: 1))
        Leytonstone.stations.append(Station(to: Wanstead, weight: 1))
        Leytonstone.stations.append(Station(to: Leyton, weight: 1))
        Limehouse.stations.append(Station(to: Shadwell, weight: 1))
        Limehouse.stations.append(Station(to: Westferry, weight: 1))
        LiverpoolStreet.stations.append(Station(to: Moorgate, weight: 1))
        LiverpoolStreet.stations.append(Station(to: Aldgate, weight: 1))
        LiverpoolStreet.stations.append(Station(to: AldgateEast, weight: 1))
        LiverpoolStreet.stations.append(Station(to: Bank, weight: 1))
        LiverpoolStreet.stations.append(Station(to: BethnalGreen, weight: 1))
        LondonBridge.stations.append(Station(to: Southwark, weight: 1))
        LondonBridge.stations.append(Station(to: Bank, weight: 1))
        LondonBridge.stations.append(Station(to: Bermondsey, weight: 1))
        LondonBridge.stations.append(Station(to: Borough, weight: 1))
        Loughton.stations.append(Station(to: BuckhurstHill, weight: 1))
        Loughton.stations.append(Station(to: Debden, weight: 1))
        MaidaVale.stations.append(Station(to: WarwickAvenue, weight: 1))
        MaidaVale.stations.append(Station(to: KilburnPark, weight: 1))
        ManorHouse.stations.append(Station(to: TurnpikeLane, weight: 1))
        ManorHouse.stations.append(Station(to: FinsburyPark, weight: 1))
        MansionHouse.stations.append(Station(to: Blackfriars, weight: 1))
        MansionHouse.stations.append(Station(to: CannonStreet, weight: 1))
        MarbleArch.stations.append(Station(to: BondStreet, weight: 1))
        MarbleArch.stations.append(Station(to: LancasterGate, weight: 1))
        Marylebone.stations.append(Station(to: BakerStreet, weight: 1))
        Marylebone.stations.append(Station(to: EdgwareRoad, weight: 1))
        MileEnd.stations.append(Station(to: Stratford, weight: 1))
        MileEnd.stations.append(Station(to: StephneyGreen, weight: 1))
        MileEnd.stations.append(Station(to: BethnalGreen, weight: 1))
        MileEnd.stations.append(Station(to: BowRoad, weight: 1))
        MillHillEast.stations.append(Station(to: FinchleyCentral, weight: 1))
        Monument.stations.append(Station(to: TowerHill, weight: 1))
        Monument.stations.append(Station(to: CannonStreet, weight: 1))
        MoorPark.stations.append(Station(to: Northwood, weight: 1))
        MoorPark.stations.append(Station(to: Rickmansworth, weight: 1))
        MoorPark.stations.append(Station(to: Croxley, weight: 1))
        Moorgate.stations.append(Station(to: OldStreet, weight: 1))
        Moorgate.stations.append(Station(to: Bank, weight: 1))
        Moorgate.stations.append(Station(to: Barbican, weight: 1))
        Moorgate.stations.append(Station(to: LiverpoolStreet, weight: 1))
        Morden.stations.append(Station(to: SouthWimbledon, weight: 1))
        MorningtonCresent.stations.append(Station(to: CamdenTown, weight: 1))
        MorningtonCresent.stations.append(Station(to: Euston, weight: 1))
        Mudchute.stations.append(Station(to: CrossharbourAndLondonArena, weight: 1))
        Mudchute.stations.append(Station(to: IslandGardens, weight: 1))
        Neasden.stations.append(Station(to: WembleyPark, weight: 1))
        Neasden.stations.append(Station(to: DollisHill, weight: 1))
        NewCross.stations.append(Station(to: SurreyQuays, weight: 1))
        NewCrossGate.stations.append(Station(to: SurreyQuays, weight: 1))
        NewburyPark.stations.append(Station(to: Barkingside, weight: 1))
        NewburyPark.stations.append(Station(to: GantsHill, weight: 1))
        NorthActon.stations.append(Station(to: WestActon, weight: 1))
        NorthActon.stations.append(Station(to: EastActon, weight: 1))
        NorthActon.stations.append(Station(to: HangerLane, weight: 1))
        NorthEaling.stations.append(Station(to: ParkRoyal, weight: 1))
        NorthEaling.stations.append(Station(to: EalingCommon, weight: 1))
        NorthGreenwich.stations.append(Station(to: CanaryWharf, weight: 1))
        NorthGreenwich.stations.append(Station(to: CanningTown, weight: 1))
        NorthHarrow.stations.append(Station(to: Pinner, weight: 1))
        NorthHarrow.stations.append(Station(to: HarrowOnTheHill, weight: 1))
        NorthWembley.stations.append(Station(to: SouthKenton, weight: 1))
        NorthWembley.stations.append(Station(to: WembleyCentral, weight: 1))
        Northfields.stations.append(Station(to: SouthEaling, weight: 1))
        Northfields.stations.append(Station(to: BostonManor, weight: 1))
        Northolt.stations.append(Station(to: SouthRuislip, weight: 1))
        Northolt.stations.append(Station(to: Greenford, weight: 1))
        NorthwickPark.stations.append(Station(to: PrestonRoad, weight: 1))
        NorthwickPark.stations.append(Station(to: HarrowOnTheHill, weight: 1))
        Northwood.stations.append(Station(to: NorthwoodHills, weight: 1))
        Northwood.stations.append(Station(to: MoorPark, weight: 1))
        NorthwoodHills.stations.append(Station(to: Northwood, weight: 1))
        NorthwoodHills.stations.append(Station(to: Pinner, weight: 1))
        NottingHillGate.stations.append(Station(to: Queensway, weight: 1))
        NottingHillGate.stations.append(Station(to: Bayswater, weight: 1))
        NottingHillGate.stations.append(Station(to: HighStreetKensington, weight: 1))
        NottingHillGate.stations.append(Station(to: HollandPark, weight: 1))
        Oakwood.stations.append(Station(to: Southgate, weight: 1))
        Oakwood.stations.append(Station(to: Cockfosters, weight: 1))
        OldStreet.stations.append(Station(to: Angel, weight: 1))
        OldStreet.stations.append(Station(to: Moorgate, weight: 1))
        Osterley.stations.append(Station(to: BostonManor, weight: 1))
        Osterley.stations.append(Station(to: HounslowEast, weight: 1))
        Oval.stations.append(Station(to: Stockwell, weight: 1))
        Oval.stations.append(Station(to: Kennington, weight: 1))
        OxfordCircus.stations.append(Station(to: PicadillyCircus, weight: 1))
        OxfordCircus.stations.append(Station(to: RegentsPark, weight: 1))
        OxfordCircus.stations.append(Station(to: TottenhamCourtRoad, weight: 1))
        OxfordCircus.stations.append(Station(to: WarrenStreet, weight: 1))
        OxfordCircus.stations.append(Station(to: BondStreet, weight: 1))
        OxfordCircus.stations.append(Station(to: GreenPark, weight: 1))
        Paddington.stations.append(Station(to: WarwickAvenue, weight: 1))
        Paddington.stations.append(Station(to: RoyalOak, weight: 1))
        Paddington.stations.append(Station(to: Bayswater, weight: 1))
        Paddington.stations.append(Station(to: EdgwareRoad, weight: 1))
        ParkRoyal.stations.append(Station(to: Alperton, weight: 1))
        ParkRoyal.stations.append(Station(to: NorthEaling, weight: 1))
        PicadillyCircus.stations.append(Station(to: CharingCross, weight: 1))
        PicadillyCircus.stations.append(Station(to: GreenPark, weight: 1))
        PicadillyCircus.stations.append(Station(to: LeicesterSquare, weight: 1))
        PicadillyCircus.stations.append(Station(to: OxfordCircus, weight: 1))
        Pimlico.stations.append(Station(to: Vauxhall, weight: 1))
        Pimlico.stations.append(Station(to: Victoria, weight: 1))
        Pinner.stations.append(Station(to: NorthHarrow, weight: 1))
        Pinner.stations.append(Station(to: NorthwoodHills, weight: 1))
        Plaistow.stations.append(Station(to: UptonPark, weight: 1))
        Plaistow.stations.append(Station(to: WestHam, weight: 1))
        Poplar.stations.append(Station(to: Westferry, weight: 1))
        Poplar.stations.append(Station(to: WestIndiaQuay, weight: 1))
        Poplar.stations.append(Station(to: AllSaints, weight: 1))
        Poplar.stations.append(Station(to: Blackwall, weight: 1))
        PrestonRoad.stations.append(Station(to: WembleyPark, weight: 1))
        PrestonRoad.stations.append(Station(to: NorthwickPark, weight: 1))
        PrinceRegent.stations.append(Station(to: RoyalAlbert, weight: 1))
        PrinceRegent.stations.append(Station(to: CustomHouse, weight: 1))
        PuddingMillLane.stations.append(Station(to: Stratford, weight: 1))
        PuddingMillLane.stations.append(Station(to: BowChurch, weight: 1))
        PutneyBridge.stations.append(Station(to: EastPutney, weight: 1))
        PutneyBridge.stations.append(Station(to: ParsonsGreen, weight: 1))
        QueensPark.stations.append(Station(to: KensalGreen, weight: 1))
        QueensPark.stations.append(Station(to: KilburnPark, weight: 1))
        Queensbury.stations.append(Station(to: CanonsPark, weight: 1))
        Queensbury.stations.append(Station(to: Kingsbury, weight: 1))
        Queensway.stations.append(Station(to: LancasterGate, weight: 1))
        Queensway.stations.append(Station(to: NottingHillGate, weight: 1))
        RavenscourtPark.stations.append(Station(to: StamfordBrook, weight: 1))
        RavenscourtPark.stations.append(Station(to: Hammersmith, weight: 1))
        RaynersLane.stations.append(Station(to: WestHarrow, weight: 1))
        RaynersLane.stations.append(Station(to: SouthHarrow, weight: 1))
        RaynersLane.stations.append(Station(to: Eastcote, weight: 1))
        Redbridge.stations.append(Station(to: Wanstead, weight: 1))
        Redbridge.stations.append(Station(to: GantsHill, weight: 1))
        RegentsPark.stations.append(Station(to: BakerStreet, weight: 1))
        RegentsPark.stations.append(Station(to: OxfordCircus, weight: 1))
        Richmond.stations.append(Station(to: KewGardens, weight: 1))
        Rickmansworth.stations.append(Station(to: Chorleywood, weight: 1))
        Rickmansworth.stations.append(Station(to: MoorPark, weight: 1))
        RodingValley.stations.append(Station(to: Woodford, weight: 1))
        RodingValley.stations.append(Station(to: Chigwell, weight: 1))
        Rotherhithe.stations.append(Station(to: Wapping, weight: 1))
        Rotherhithe.stations.append(Station(to: CanadaWater, weight: 1))
        RoyalAlbert.stations.append(Station(to: BecktonPark, weight: 1))
        RoyalAlbert.stations.append(Station(to: PrinceRegent, weight: 1))
        RoyalOak.stations.append(Station(to: WestbournePark, weight: 1))
        RoyalOak.stations.append(Station(to: Paddington, weight: 1))
        RoyalVictoria.stations.append(Station(to: CanningTown, weight: 1))
        RoyalVictoria.stations.append(Station(to: CustomHouse, weight: 1))
        Ruislip.stations.append(Station(to: RuislipManor, weight: 1))
        Ruislip.stations.append(Station(to: Ickenham, weight: 1))
        RuislipGardens.stations.append(Station(to: SouthRuislip, weight: 1))
        RuislipGardens.stations.append(Station(to: WestRuislip, weight: 1))
        RuislipManor.stations.append(Station(to: Eastcote, weight: 1))
        RuislipManor.stations.append(Station(to: Ruislip, weight: 1))
        RussellSquare.stations.append(Station(to: Holborn, weight: 1))
        RussellSquare.stations.append(Station(to: KingsCross, weight: 1))
        SevenSisters.stations.append(Station(to: TottenhamHale, weight: 1))
        SevenSisters.stations.append(Station(to: FinsburyPark, weight: 1))
        Shadwell.stations.append(Station(to: TowerGateway, weight: 1))
        Shadwell.stations.append(Station(to: Wapping, weight: 1))
        Shadwell.stations.append(Station(to: Whitechapel, weight: 1))
        Shadwell.stations.append(Station(to: Bank, weight: 1))
        Shadwell.stations.append(Station(to: Limehouse, weight: 1))
        ShephardsBush.stations.append(Station(to: HollandPark, weight: 1))
        ShephardsBush.stations.append(Station(to: WhiteCity, weight: 1))
        ShephardsBush.stations.append(Station(to: GoldhawkRoad, weight: 1))
        ShephardsBush.stations.append(Station(to: LatimerRoad, weight: 1))
        Shoreditch.stations.append(Station(to: Whitechapel, weight: 1))
        SloaneSquare.stations.append(Station(to: SouthKensington, weight: 1))
        SloaneSquare.stations.append(Station(to: Victoria, weight: 1))
        Snaresbrook.stations.append(Station(to: SouthWoodford, weight: 1))
        Snaresbrook.stations.append(Station(to: Leytonstone, weight: 1))
        SouthEaling.stations.append(Station(to: ActonTown, weight: 1))
        SouthEaling.stations.append(Station(to: Northfields, weight: 1))
        SouthHarrow.stations.append(Station(to: SudburyHill, weight: 1))
        SouthHarrow.stations.append(Station(to: RaynersLane, weight: 1))
        SouthKensington.stations.append(Station(to: GloucesterRoad, weight: 1))
        SouthKensington.stations.append(Station(to: Knightsbridge, weight: 1))
        SouthKensington.stations.append(Station(to: SloaneSquare, weight: 1))
        SouthKenton.stations.append(Station(to: Kenton, weight: 1))
        SouthKenton.stations.append(Station(to: NorthWembley, weight: 1))
        SouthQuays.stations.append(Station(to: CrossharbourAndLondonArena, weight: 1))
        SouthQuays.stations.append(Station(to: HeronQuays, weight: 1))
        SouthRuislip.stations.append(Station(to: Northolt, weight: 1))
        SouthRuislip.stations.append(Station(to: RuislipGardens, weight: 1))
        SouthWimbledon.stations.append(Station(to: ColliersWood, weight: 1))
        SouthWimbledon.stations.append(Station(to: Morden, weight: 1))
        SouthWoodford.stations.append(Station(to: Woodford, weight: 1))
        SouthWoodford.stations.append(Station(to: Snaresbrook, weight: 1))
        Southfields.stations.append(Station(to: WimbledonPark, weight: 1))
        Southfields.stations.append(Station(to: EastPutney, weight: 1))
        Southgate.stations.append(Station(to: ArnosGrove, weight: 1))
        Southgate.stations.append(Station(to: Oakwood, weight: 1))
        Southwark.stations.append(Station(to: Waterloo, weight: 1))
        Southwark.stations.append(Station(to: LondonBridge, weight: 1))
        StJamesPark.stations.append(Station(to: Victoria, weight: 1))
        StJamesPark.stations.append(Station(to: Westminster, weight: 1))
        StJohnsWood.stations.append(Station(to: SwissCottage, weight: 1))
        StJohnsWood.stations.append(Station(to: BakerStreet, weight: 1))
        StPauls.stations.append(Station(to: Bank, weight: 1))
        StPauls.stations.append(Station(to: ChanceryLane, weight: 1))
        StamfordBrook.stations.append(Station(to: TurnhamGreen, weight: 1))
        StamfordBrook.stations.append(Station(to: RavenscourtPark, weight: 1))
        Stanmore.stations.append(Station(to: CanonsPark, weight: 1))
        StephneyGreen.stations.append(Station(to: Whitechapel, weight: 1))
        StephneyGreen.stations.append(Station(to: MileEnd, weight: 1))
        Stockwell.stations.append(Station(to: Vauxhall, weight: 1))
        Stockwell.stations.append(Station(to: Brixton, weight: 1))
        Stockwell.stations.append(Station(to: ClaphamNorth, weight: 1))
        Stockwell.stations.append(Station(to: Oval, weight: 1))
        StonebridgePark.stations.append(Station(to: WembleyCentral, weight: 1))
        StonebridgePark.stations.append(Station(to: Harlesden, weight: 1))
        Stratford.stations.append(Station(to: WestHam, weight: 1))
        Stratford.stations.append(Station(to: Leyton, weight: 1))
        Stratford.stations.append(Station(to: MileEnd, weight: 1))
        Stratford.stations.append(Station(to: PuddingMillLane, weight: 1))
        SudburyHill.stations.append(Station(to: SudburyTown, weight: 1))
        SudburyHill.stations.append(Station(to: SouthHarrow, weight: 1))
        SudburyTown.stations.append(Station(to: Alperton, weight: 1))
        SudburyTown.stations.append(Station(to: SudburyHill, weight: 1))
        SurreyQuays.stations.append(Station(to: CanadaWater, weight: 1))
        SurreyQuays.stations.append(Station(to: NewCross, weight: 1))
        SurreyQuays.stations.append(Station(to: NewCrossGate, weight: 1))
        SwissCottage.stations.append(Station(to: FinchleyRoad, weight: 1))
        SwissCottage.stations.append(Station(to: StJohnsWood, weight: 1))
        Temple.stations.append(Station(to: Blackfriars, weight: 1))
        Temple.stations.append(Station(to: Embankment, weight: 1))
        TheydonBois.stations.append(Station(to: Debden, weight: 1))
        TheydonBois.stations.append(Station(to: Epping, weight: 1))
        TootingBec.stations.append(Station(to: TootingBroadway, weight: 1))
        TootingBec.stations.append(Station(to: Balham, weight: 1))
        TootingBroadway.stations.append(Station(to: ColliersWood, weight: 1))
        TootingBroadway.stations.append(Station(to: TootingBec, weight: 1))
        TottenhamCourtRoad.stations.append(Station(to: GoodgeStreet, weight: 1))
        TottenhamCourtRoad.stations.append(Station(to: Holborn, weight: 1))
        TottenhamCourtRoad.stations.append(Station(to: LeicesterSquare, weight: 1))
        TottenhamCourtRoad.stations.append(Station(to: OxfordCircus, weight: 1))
        TottenhamHale.stations.append(Station(to: BlackhorseRoad, weight: 1))
        TottenhamHale.stations.append(Station(to: SevenSisters, weight: 1))
        TotteridgeAndWhetstone.stations.append(Station(to: WoodsidePark, weight: 1))
        TotteridgeAndWhetstone.stations.append(Station(to: HighBarnet, weight: 1))
        TowerGateway.stations.append(Station(to: Shadwell, weight: 1))
        TowerHill.stations.append(Station(to: Aldgate, weight: 1))
        TowerHill.stations.append(Station(to: AldgateEast, weight: 1))
        TowerHill.stations.append(Station(to: Monument, weight: 1))
        TufnellPark.stations.append(Station(to: Archway, weight: 1))
        TufnellPark.stations.append(Station(to: KentishTown, weight: 1))
        TurnhamGreen.stations.append(Station(to: ActonTown, weight: 1))
        TurnhamGreen.stations.append(Station(to: ChiswickPark, weight: 1))
        TurnhamGreen.stations.append(Station(to: Gunnersbury, weight: 1))
        TurnhamGreen.stations.append(Station(to: Hammersmith, weight: 1))
        TurnhamGreen.stations.append(Station(to: StamfordBrook, weight: 1))
        TurnpikeLane.stations.append(Station(to: WoodGreen, weight: 1))
        TurnpikeLane.stations.append(Station(to: ManorHouse, weight: 1))
        Upminster.stations.append(Station(to: UpminsterBridge, weight: 1))
        UpminsterBridge.stations.append(Station(to: Hornchurch, weight: 1))
        UpminsterBridge.stations.append(Station(to: Upminster, weight: 1))
        Upney.stations.append(Station(to: Barking, weight: 1))
        Upney.stations.append(Station(to: Becontree, weight: 1))
        UptonPark.stations.append(Station(to: EastHam, weight: 1))
        UptonPark.stations.append(Station(to: Plaistow, weight: 1))
        Uxbridge.stations.append(Station(to: Hillingdon, weight: 1))
        Vauxhall.stations.append(Station(to: Pimlico, weight: 1))
        Vauxhall.stations.append(Station(to: Stockwell, weight: 1))
        Victoria.stations.append(Station(to: GreenPark, weight: 1))
        Victoria.stations.append(Station(to: Pimlico, weight: 1))
        Victoria.stations.append(Station(to: SloaneSquare, weight: 1))
        Victoria.stations.append(Station(to: StJamesPark, weight: 1))
        WalthamstowCentral.stations.append(Station(to: BlackhorseRoad, weight: 1))
        Wanstead.stations.append(Station(to: Leytonstone, weight: 1))
        Wanstead.stations.append(Station(to: Redbridge, weight: 1))
        Wapping.stations.append(Station(to: Rotherhithe, weight: 1))
        Wapping.stations.append(Station(to: Shadwell, weight: 1))
        WarrenStreet.stations.append(Station(to: Euston, weight: 1))
        WarrenStreet.stations.append(Station(to: GoodgeStreet, weight: 1))
        WarrenStreet.stations.append(Station(to: OxfordCircus, weight: 1))
        WarwickAvenue.stations.append(Station(to: MaidaVale, weight: 1))
        WarwickAvenue.stations.append(Station(to: Paddington, weight: 1))
        Waterloo.stations.append(Station(to: Westminster, weight: 1))
        Waterloo.stations.append(Station(to: Bank, weight: 1))
        Waterloo.stations.append(Station(to: Embankment, weight: 1))
        Waterloo.stations.append(Station(to: Kennington, weight: 1))
        Waterloo.stations.append(Station(to: LambethNorth, weight: 1))
        Waterloo.stations.append(Station(to: Southwark, weight: 1))
        Watford.stations.append(Station(to: Croxley, weight: 1))
        WembleyCentral.stations.append(Station(to: NorthWembley, weight: 1))
        WembleyCentral.stations.append(Station(to: StonebridgePark, weight: 1))
        WembleyPark.stations.append(Station(to: FinchleyRoad, weight: 1))
        WembleyPark.stations.append(Station(to: Kingsbury, weight: 1))
        WembleyPark.stations.append(Station(to: Neasden, weight: 1))
        WembleyPark.stations.append(Station(to: PrestonRoad, weight: 1))
        WestActon.stations.append(Station(to: EalingBroadway, weight: 1))
        WestActon.stations.append(Station(to: NorthActon, weight: 1))
        WestBrompton.stations.append(Station(to: EarlsCourt, weight: 1))
        WestBrompton.stations.append(Station(to: FulhamBroadway, weight: 1))
        WestFinchley.stations.append(Station(to: WoodsidePark, weight: 1))
        WestFinchley.stations.append(Station(to: FinchleyCentral, weight: 1))
        WestHam.stations.append(Station(to: BromleyByBow, weight: 1))
        WestHam.stations.append(Station(to: CanningTown, weight: 1))
        WestHam.stations.append(Station(to: Plaistow, weight: 1))
        WestHam.stations.append(Station(to: Stratford, weight: 1))
        WestHampstead.stations.append(Station(to: FinchleyRoad, weight: 1))
        WestHampstead.stations.append(Station(to: Kilburn, weight: 1))
        WestHarrow.stations.append(Station(to: HarrowOnTheHill, weight: 1))
        WestHarrow.stations.append(Station(to: RaynersLane, weight: 1))
        WestIndiaQuay.stations.append(Station(to: CanaryWharf, weight: 1))
        WestIndiaQuay.stations.append(Station(to: Poplar, weight: 1))
        WestIndiaQuay.stations.append(Station(to: Westferry, weight: 1))
        WestKensington.stations.append(Station(to: BaronsCourt, weight: 1))
        WestKensington.stations.append(Station(to: EarlsCourt, weight: 1))
        WestRuislip.stations.append(Station(to: RuislipGardens, weight: 1))
        WestbournePark.stations.append(Station(to: LadbrokeGrove, weight: 1))
        WestbournePark.stations.append(Station(to: RoyalOak, weight: 1))
        Westferry.stations.append(Station(to: WestIndiaQuay, weight: 1))
        Westferry.stations.append(Station(to: Limehouse, weight: 1))
        Westferry.stations.append(Station(to: Poplar, weight: 1))
        Westminster.stations.append(Station(to: Embankment, weight: 1))
        Westminster.stations.append(Station(to: GreenPark, weight: 1))
        Westminster.stations.append(Station(to: StJamesPark, weight: 1))
        Westminster.stations.append(Station(to: Waterloo, weight: 1))
        WhiteCity.stations.append(Station(to: EastActon, weight: 1))
        WhiteCity.stations.append(Station(to: ShephardsBush, weight: 1))
        Whitechapel.stations.append(Station(to: AldgateEast, weight: 1))
        Whitechapel.stations.append(Station(to: Shadwell, weight: 1))
        Whitechapel.stations.append(Station(to: Shoreditch, weight: 1))
        Whitechapel.stations.append(Station(to: StephneyGreen, weight: 1))
        WillesdenGreen.stations.append(Station(to: DollisHill, weight: 1))
        WillesdenGreen.stations.append(Station(to: Kilburn, weight: 1))
        WillesdenJunction.stations.append(Station(to: Harlesden, weight: 1))
        WillesdenJunction.stations.append(Station(to: KensalGreen, weight: 1))
        Wimbledon.stations.append(Station(to: WimbledonPark, weight: 1))
        WimbledonPark.stations.append(Station(to: Southfields, weight: 1))
        WimbledonPark.stations.append(Station(to: Wimbledon, weight: 1))
        WoodGreen.stations.append(Station(to: BoundsGreen, weight: 1))
        WoodGreen.stations.append(Station(to: TurnpikeLane, weight: 1))
        Woodford.stations.append(Station(to: BuckhurstHill, weight: 1))
        Woodford.stations.append(Station(to: RodingValley, weight: 1))
        Woodford.stations.append(Station(to: SouthWoodford, weight: 1))
        WoodsidePark.stations.append(Station(to: TotteridgeAndWhetstone, weight: 1))
        WoodsidePark.stations.append(Station(to: WestFinchley, weight: 1))
        
        
    }
    
    
    func checkNode() {
        
        if sourceNode.name == ActonTown.name {
            sourceNode = ActonTown
        } else if sourceNode.name == Aldgate.name {
            sourceNode = Aldgate
        } else if sourceNode.name == AldgateEast.name {
            sourceNode = AldgateEast
        } else if sourceNode.name == AllSaints.name {
            sourceNode = AllSaints
        } else if sourceNode.name == Alperton.name {
            sourceNode = Alperton
        } else if sourceNode.name == Amersham.name {
            sourceNode = Amersham
        } else if sourceNode.name == Angel.name {
            sourceNode = Angel
        } else if sourceNode.name == Archway.name {
            sourceNode = Archway
        } else if sourceNode.name == ArnosGrove.name {
            sourceNode = ArnosGrove
        } else if sourceNode.name == Arsenal.name {
            sourceNode = Arsenal
        } else if sourceNode.name == BakerStreet.name {
            sourceNode = BakerStreet
        } else if sourceNode.name == Balham.name {
            sourceNode = Balham
        } else if sourceNode.name == Bank.name {
            sourceNode = Bank
        } else if sourceNode.name == Barbican.name {
            sourceNode = Barbican
        } else if sourceNode.name == Barking.name {
            sourceNode = Barking
        } else if sourceNode.name == Barkingside.name {
            sourceNode = Barkingside
        } else if sourceNode.name == BaronsCourt.name {
            sourceNode = BaronsCourt
        } else if sourceNode.name == Bayswater.name {
            sourceNode = Bayswater
        } else if sourceNode.name == Beckton.name {
            sourceNode = Beckton
        } else if sourceNode.name == BecktonPark.name {
            sourceNode = BecktonPark
        } else if sourceNode.name == Becontree.name {
            sourceNode = Becontree
        } else if sourceNode.name == BelsizePark.name {
            sourceNode = BelsizePark
        } else if sourceNode.name == Bermondsey.name {
            sourceNode = Bermondsey
        } else if sourceNode.name == BethnalGreen.name {
            sourceNode = BethnalGreen
        } else if sourceNode.name == Blackfriars.name {
            sourceNode = Blackfriars
        } else if sourceNode.name == BlackhorseRoad.name {
            sourceNode = BlackhorseRoad
        } else if sourceNode.name == Blackwall.name {
            sourceNode = Blackwall
        } else if sourceNode.name == BondStreet.name {
            sourceNode = BondStreet
        } else if sourceNode.name == Borough.name {
            sourceNode = Borough
        } else if sourceNode.name == BostonManor.name {
            sourceNode = BostonManor
        } else if sourceNode.name == BoundsGreen.name {
            sourceNode = BoundsGreen
        } else if sourceNode.name == BowChurch.name {
            sourceNode = BowChurch
        } else if sourceNode.name == BowRoad.name {
            sourceNode = BowRoad
        } else if sourceNode.name == BrentCross.name {
            sourceNode = BrentCross
        } else if sourceNode.name == Brixton.name {
            sourceNode = Brixton
        } else if sourceNode.name == BromleyByBow.name {
            sourceNode = BromleyByBow
        } else if sourceNode.name == BuckhurstHill.name {
            sourceNode = BuckhurstHill
        } else if sourceNode.name == BurntOak.name {
            sourceNode = BurntOak
        } else if sourceNode.name == CaledonianRoad.name {
            sourceNode = CaledonianRoad
        } else if sourceNode.name == CamdenTown.name {
            sourceNode = CamdenTown
        } else if sourceNode.name == CanadaWater.name {
            sourceNode = CanadaWater
        } else if sourceNode.name == CanaryWharf.name {
            sourceNode = CanaryWharf
        } else if sourceNode.name == CanningTown.name {
            sourceNode = CanningTown
        } else if sourceNode.name == CannonStreet.name {
            sourceNode = CannonStreet
        } else if sourceNode.name == CanonsPark.name {
            sourceNode = CanonsPark
        } else if sourceNode.name == ChalfrontAndLatimer.name {
            sourceNode = ChalfrontAndLatimer
        } else if sourceNode.name == ChalkFarm.name {
            sourceNode = ChalkFarm
        } else if sourceNode.name == ChanceryLane.name {
            sourceNode = ChanceryLane
        } else if sourceNode.name == CharingCross.name {
            sourceNode = CharingCross
        } else if sourceNode.name == Chesham.name {
            sourceNode = Chesham
        } else if sourceNode.name == Chigwell.name {
            sourceNode = Chigwell
        } else if sourceNode.name == ChiswickPark.name {
            sourceNode = ChiswickPark
        } else if sourceNode.name == Chorleywood.name {
            sourceNode = Chorleywood
        } else if sourceNode.name == ClaphamCommon.name {
            sourceNode = ClaphamCommon
        } else if sourceNode.name == ClaphamNorth.name {
            sourceNode = ClaphamNorth
        } else if sourceNode.name == ClaphamSouth.name {
            sourceNode = ClaphamSouth
        } else if sourceNode.name == Cockfosters.name {
            sourceNode = Cockfosters
        } else if sourceNode.name == Colindale.name {
            sourceNode = Colindale
        } else if sourceNode.name == ColliersWood.name {
            sourceNode = ColliersWood
        } else if sourceNode.name == CoventGarden.name {
            sourceNode = CoventGarden
        } else if sourceNode.name == CrossharbourAndLondonArena.name {
            sourceNode = CrossharbourAndLondonArena
        } else if sourceNode.name == Croxley.name {
            sourceNode = Croxley
        } else if sourceNode.name == CustomHouse.name {
            sourceNode = CustomHouse
        } else if sourceNode.name == CuttySark.name {
            sourceNode = CuttySark
        } else if sourceNode.name == Cyprus.name {
            sourceNode = Cyprus
        } else if sourceNode.name == DagenhamEast.name {
            sourceNode = DagenhamEast
        } else if sourceNode.name == DagenhamHeathway.name {
            sourceNode = DagenhamHeathway
        } else if sourceNode.name == Debden.name {
            sourceNode = Debden
        } else if sourceNode.name == DeptfordBridge.name {
            sourceNode = DeptfordBridge
        } else if sourceNode.name == DevonsRoad.name {
            sourceNode = DevonsRoad
        } else if sourceNode.name == DollisHill.name {
            sourceNode = DollisHill
        } else if sourceNode.name == EalingBroadway.name {
            sourceNode = EalingBroadway
        } else if sourceNode.name == EalingCommon.name {
            sourceNode = EalingCommon
        } else if sourceNode.name == EarlsCourt.name {
            sourceNode = EarlsCourt
        } else if sourceNode.name == EastActon.name {
            sourceNode = EastActon
        } else if sourceNode.name == EastFinchley.name {
            sourceNode = EastFinchley
        } else if sourceNode.name == EastHam.name {
            sourceNode = EastHam
        } else if sourceNode.name == EastIndia.name {
            sourceNode = EastIndia
        } else if sourceNode.name == EastPutney.name {
            sourceNode = EastPutney
        } else if sourceNode.name == Eastcote.name {
            sourceNode = Eastcote
        } else if sourceNode.name == Edgware.name {
            sourceNode = Edgware
        } else if sourceNode.name == EdgwareRoad.name {
            sourceNode = EdgwareRoad
        } else if sourceNode.name == ElephantAndCastle.name {
            sourceNode = ElephantAndCastle
        } else if sourceNode.name == ElmPark.name {
            sourceNode = ElmPark
        } else if sourceNode.name == ElversonRoad.name {
            sourceNode = ElversonRoad
        } else if sourceNode.name == Embankment.name {
            sourceNode = Embankment
        } else if sourceNode.name == Epping.name {
            sourceNode = Epping
        } else if sourceNode.name == Euston.name {
            sourceNode = Euston
        } else if sourceNode.name == EustonSquare.name {
            sourceNode = EustonSquare
        } else if sourceNode.name == Fairlop.name {
            sourceNode = Fairlop
        } else if sourceNode.name == Farringdon.name {
            sourceNode = Farringdon
        } else if sourceNode.name == FinchleyCentral.name {
            sourceNode = FinchleyCentral
        } else if sourceNode.name == FinchleyRoad.name {
            sourceNode = FinchleyRoad
        } else if sourceNode.name == FinsburyPark.name {
            sourceNode = FinsburyPark
        } else if sourceNode.name == FulhamBroadway.name {
            sourceNode = FulhamBroadway
        } else if sourceNode.name == GallionsReach.name {
            sourceNode = GallionsReach
        } else if sourceNode.name == GantsHill.name {
            sourceNode = GantsHill
        } else if sourceNode.name == GloucesterRoad.name {
            sourceNode = GloucesterRoad
        } else if sourceNode.name == GoldersGreen.name {
            sourceNode = GoldersGreen
        } else if sourceNode.name == GoldhawkRoad.name {
            sourceNode = GoldhawkRoad
        } else if sourceNode.name == GoodgeStreet.name {
            sourceNode = GoodgeStreet
        } else if sourceNode.name == GrangeHill.name {
            sourceNode = GrangeHill
        } else if sourceNode.name == GreatPortlandStreet.name {
            sourceNode = GreatPortlandStreet
        } else if sourceNode.name == GreenPark.name {
            sourceNode = GreenPark
        } else if sourceNode.name == Greenford.name {
            sourceNode = Greenford
        } else if sourceNode.name == Greenwich.name {
            sourceNode = Greenwich
        } else if sourceNode.name == Gunnersbury.name {
            sourceNode = Gunnersbury
        } else if sourceNode.name == Hainault.name {
            sourceNode = Hainault
        } else if sourceNode.name == Hammersmith.name {
            sourceNode = Hammersmith
        } else if sourceNode.name == Hampstead.name {
            sourceNode = Hampstead
        } else if sourceNode.name == HangerLane.name {
            sourceNode = HangerLane
        } else if sourceNode.name == Harlesden.name {
            sourceNode = Harlesden
        } else if sourceNode.name == HarrowAndWealdston.name {
            sourceNode = HarrowAndWealdston
        } else if sourceNode.name == HarrowOnTheHill.name {
            sourceNode = HarrowOnTheHill
        } else if sourceNode.name == HattonCross.name {
            sourceNode = HattonCross
        } else if sourceNode.name == HeathrowTerminal4.name {
            sourceNode = HeathrowTerminal4
        } else if sourceNode.name == HeathrowTerminal123.name {
            sourceNode = HeathrowTerminal123
        } else if sourceNode.name == HeathrowTerminal5.name {
            sourceNode = HeathrowTerminal5
        } else if sourceNode.name == HendonCentral.name {
            sourceNode = HendonCentral
        } else if sourceNode.name == HighBarnet.name {
            sourceNode = HighBarnet
        } else if sourceNode.name == HighStreetKensington.name {
            sourceNode = HighStreetKensington
        } else if sourceNode.name == HighburyAndIslington.name {
            sourceNode = HighburyAndIslington
        } else if sourceNode.name == Highgate.name {
            sourceNode = Highgate
        } else if sourceNode.name == Hillingdon.name {
            sourceNode = Hillingdon
        } else if sourceNode.name == Holborn.name {
            sourceNode = Holborn
        } else if sourceNode.name == HollandPark.name {
            sourceNode = HollandPark
        } else if sourceNode.name == HollowayRoad.name {
            sourceNode = HollowayRoad
        } else if sourceNode.name == Hornchurch.name {
            sourceNode = Hornchurch
        } else if sourceNode.name == HounslowCentral.name {
            sourceNode = HounslowCentral
        } else if sourceNode.name == HounslowEast.name {
            sourceNode = HounslowEast
        } else if sourceNode.name == HounslowWest.name {
            sourceNode = HounslowWest
        } else if sourceNode.name == HydeParkCorner.name {
            sourceNode = HydeParkCorner
        } else if sourceNode.name == Ickenham.name {
            sourceNode = Ickenham
        } else if sourceNode.name == IslandGardens.name {
            sourceNode = IslandGardens
        } else if sourceNode.name == Kennington.name {
            sourceNode = Kennington
        } else if sourceNode.name == KensalGreen.name {
            sourceNode = KensalGreen
        } else if sourceNode.name == KensintonOlympia.name {
            sourceNode = KensintonOlympia
        } else if sourceNode.name == KentishTown.name {
            sourceNode = KentishTown
        } else if sourceNode.name == Kenton.name {
            sourceNode = Kenton
        } else if sourceNode.name == KewGardens.name {
            sourceNode = KewGardens
        } else if sourceNode.name == Kilburn.name {
            sourceNode = Kilburn
        } else if sourceNode.name == KilburnPark.name {
            sourceNode = KilburnPark
        } else if sourceNode.name == KingsCross.name {
            sourceNode = KingsCross
        } else if sourceNode.name == Kingsbury.name {
            sourceNode = Kingsbury
        } else if sourceNode.name == Knightsbridge.name {
            sourceNode = Knightsbridge
        } else if sourceNode.name == LadbrokeGrove.name {
            sourceNode = LadbrokeGrove
        } else if sourceNode.name == LambethNorth.name {
            sourceNode = LambethNorth
        } else if sourceNode.name == LancasterGate.name {
            sourceNode = LancasterGate
        } else if sourceNode.name == LatimerRoad.name {
            sourceNode = LatimerRoad
        } else if sourceNode.name == LeicesterSquare.name {
            sourceNode = LeicesterSquare
        } else if sourceNode.name == Lewisham.name {
            sourceNode = Lewisham
        } else if sourceNode.name == Leyton.name {
            sourceNode = Leyton
        } else if sourceNode.name == Leytonstone.name {
            sourceNode = Leytonstone
        } else if sourceNode.name == Limehouse.name {
            sourceNode = Limehouse
        } else if sourceNode.name == LiverpoolStreet.name {
            sourceNode = LiverpoolStreet
        } else if sourceNode.name == LondonBridge.name {
            sourceNode = LondonBridge
        } else if sourceNode.name == Loughton.name {
            sourceNode = Loughton
        } else if sourceNode.name == MaidaVale.name {
            sourceNode = MaidaVale
        } else if sourceNode.name == ManorHouse.name {
            sourceNode = ManorHouse
        } else if sourceNode.name == MansionHouse.name {
            sourceNode = MansionHouse
        } else if sourceNode.name == MarbleArch.name {
            sourceNode = MarbleArch
        } else if sourceNode.name == Marylebone.name {
            sourceNode = Marylebone
        } else if sourceNode.name == MileEnd.name {
            sourceNode = MileEnd
        } else if sourceNode.name == MillHillEast.name {
            sourceNode = MillHillEast
        } else if sourceNode.name == Monument.name {
            sourceNode = Monument
        } else if sourceNode.name == MoorPark.name {
            sourceNode = MoorPark
        } else if sourceNode.name == Moorgate.name {
            sourceNode = Moorgate
        } else if sourceNode.name == Morden.name {
            sourceNode = Morden
        } else if sourceNode.name == MorningtonCresent.name {
            sourceNode = MorningtonCresent
        } else if sourceNode.name == Mudchute.name {
            sourceNode = Mudchute
        } else if sourceNode.name == Neasden.name {
            sourceNode = Neasden
        } else if sourceNode.name == NewCross.name {
            sourceNode = NewCross
        } else if sourceNode.name == NewCrossGate.name {
            sourceNode = NewCrossGate
        } else if sourceNode.name == NewburyPark.name {
            sourceNode = NewburyPark
        } else if sourceNode.name == NorthActon.name {
            sourceNode = NorthActon
        } else if sourceNode.name == NorthEaling.name {
            sourceNode = NorthEaling
        } else if sourceNode.name == NorthGreenwich.name {
            sourceNode = NorthGreenwich
        } else if sourceNode.name == NorthHarrow.name {
            sourceNode = NorthHarrow
        } else if sourceNode.name == NorthWembley.name {
            sourceNode = NorthWembley
        } else if sourceNode.name == Northfields.name {
            sourceNode = Northfields
        } else if sourceNode.name == Northolt.name {
            sourceNode = Northolt
        } else if sourceNode.name == NorthwickPark.name {
            sourceNode = NorthwickPark
        } else if sourceNode.name == Northwood.name {
            sourceNode = Northwood
        } else if sourceNode.name == NorthwoodHills.name {
            sourceNode = NorthwoodHills
        } else if sourceNode.name == NottingHillGate.name {
            sourceNode = NottingHillGate
        } else if sourceNode.name == Oakwood.name {
            sourceNode = Oakwood
        } else if sourceNode.name == OldStreet.name {
            sourceNode = OldStreet
        } else if sourceNode.name == Osterley.name {
            sourceNode = Osterley
        } else if sourceNode.name == Oval.name {
            sourceNode = Oval
        } else if sourceNode.name == OxfordCircus.name {
            sourceNode = OxfordCircus
        } else if sourceNode.name == Paddington.name {
            sourceNode = Paddington
        } else if sourceNode.name == ParkRoyal.name {
            sourceNode = ParkRoyal
        } else if sourceNode.name == ParsonsGreen.name {
            sourceNode = ParsonsGreen
        } else if sourceNode.name == Perivale.name {
            sourceNode = Perivale
        } else if sourceNode.name == PicadillyCircus.name {
            sourceNode = PicadillyCircus
        } else if sourceNode.name == Pimlico.name {
            sourceNode = Pimlico
        } else if sourceNode.name == Pinner.name {
            sourceNode = Pinner
        } else if sourceNode.name == Plaistow.name {
            sourceNode = Plaistow
        } else if sourceNode.name == Poplar.name {
            sourceNode = Poplar
        } else if sourceNode.name == PrestonRoad.name {
            sourceNode = PrestonRoad
        } else if sourceNode.name == PrinceRegent.name {
            sourceNode = PrinceRegent
        } else if sourceNode.name == PuddingMillLane.name {
            sourceNode = PuddingMillLane
        } else if sourceNode.name == PutneyBridge.name {
            sourceNode = PutneyBridge
        } else if sourceNode.name == QueensPark.name {
            sourceNode = QueensPark
        } else if sourceNode.name == Queensbury.name {
            sourceNode = Queensbury
        } else if sourceNode.name == Queensway.name {
            sourceNode = Queensway
        } else if sourceNode.name == RavenscourtPark.name {
            sourceNode = RavenscourtPark
        } else if sourceNode.name == RaynersLane.name {
            sourceNode = RaynersLane
        } else if sourceNode.name == Redbridge.name {
            sourceNode = Redbridge
        } else if sourceNode.name == RegentsPark.name {
            sourceNode = RegentsPark
        } else if sourceNode.name == Richmond.name {
            sourceNode = Richmond
        } else if sourceNode.name == Rickmansworth.name {
            sourceNode = Rickmansworth
        } else if sourceNode.name == RodingValley.name {
            sourceNode = RodingValley
        } else if sourceNode.name == Rotherhithe.name {
            sourceNode = Rotherhithe
        } else if sourceNode.name == RoyalAlbert.name {
            sourceNode = RoyalAlbert
        } else if sourceNode.name == RoyalOak.name {
            sourceNode = RoyalOak
        } else if sourceNode.name == RoyalVictoria.name {
            sourceNode = RoyalVictoria
        } else if sourceNode.name == Ruislip.name {
            sourceNode = Ruislip
        } else if sourceNode.name == RuislipGardens.name {
            sourceNode = RuislipGardens
        } else if sourceNode.name == RuislipManor.name {
            sourceNode = RuislipManor
        } else if sourceNode.name == RussellSquare.name {
            sourceNode = RussellSquare
        } else if sourceNode.name == SevenSisters.name {
            sourceNode = SevenSisters
        } else if sourceNode.name == Shadwell.name {
            sourceNode = Shadwell
        } else if sourceNode.name == ShephardsBush.name {
            sourceNode = ShephardsBush
        } else if sourceNode.name == Shoreditch.name {
            sourceNode = Shoreditch
        } else if sourceNode.name == SloaneSquare.name {
            sourceNode = SloaneSquare
        } else if sourceNode.name == Snaresbrook.name {
            sourceNode = Snaresbrook
        } else if sourceNode.name == SouthEaling.name {
            sourceNode = SouthEaling
        } else if sourceNode.name == SouthHarrow.name {
            sourceNode = SouthHarrow
        } else if sourceNode.name == SouthKensington.name {
            sourceNode = SouthKensington
        } else if sourceNode.name == SouthKenton.name {
            sourceNode = SouthKenton
        } else if sourceNode.name == SouthQuays.name {
            sourceNode = SouthQuays
        } else if sourceNode.name == SouthRuislip.name {
            sourceNode = SouthRuislip
        } else if sourceNode.name == SouthWimbledon.name {
            sourceNode = SouthWimbledon
        } else if sourceNode.name == SouthWoodford.name {
            sourceNode = SouthWoodford
        } else if sourceNode.name == Southfields.name {
            sourceNode = Southfields
        } else if sourceNode.name == Southgate.name {
            sourceNode = Southgate
        } else if sourceNode.name == Southwark.name {
            sourceNode = Southwark
        } else if sourceNode.name == StJamesPark.name {
            sourceNode = StJamesPark
        } else if sourceNode.name == StJohnsWood.name {
            sourceNode = StJohnsWood
        } else if sourceNode.name == StPauls.name {
            sourceNode = StPauls
        } else if sourceNode.name == StamfordBrook.name {
            sourceNode = StamfordBrook
        } else if sourceNode.name == Stanmore.name {
            sourceNode = Stanmore
        } else if sourceNode.name == StephneyGreen.name {
            sourceNode = StephneyGreen
        } else if sourceNode.name == Stockwell.name {
            sourceNode = Stockwell
        } else if sourceNode.name == StonebridgePark.name {
            sourceNode = StonebridgePark
        } else if sourceNode.name == Stratford.name {
            sourceNode = Stratford
        } else if sourceNode.name == SudburyHill.name {
            sourceNode = SudburyHill
        } else if sourceNode.name == SudburyTown.name {
            sourceNode = SudburyTown
        } else if sourceNode.name == SurreyQuays.name {
            sourceNode = SurreyQuays
        } else if sourceNode.name == SwissCottage.name {
            sourceNode = SwissCottage
        } else if sourceNode.name == Temple.name {
            sourceNode = Temple
        } else if sourceNode.name == TheydonBois.name {
            sourceNode = TheydonBois
        } else if sourceNode.name == TootingBec.name {
            sourceNode = TootingBec
        } else if sourceNode.name == TootingBroadway.name {
            sourceNode = TootingBroadway
        } else if sourceNode.name == TottenhamCourtRoad.name {
            sourceNode = TottenhamCourtRoad
        } else if sourceNode.name == TottenhamHale.name {
            sourceNode = TottenhamHale
        } else if sourceNode.name == TotteridgeAndWhetstone.name {
            sourceNode = TotteridgeAndWhetstone
        } else if sourceNode.name == TowerGateway.name {
            sourceNode = TowerGateway
        } else if sourceNode.name == TowerHill.name {
            sourceNode = TowerHill
        } else if sourceNode.name == TufnellPark.name {
            sourceNode = TufnellPark
        } else if sourceNode.name == TurnhamGreen.name {
            sourceNode = TurnhamGreen
        } else if sourceNode.name == TurnpikeLane.name {
            sourceNode = TurnpikeLane
        } else if sourceNode.name == Upminster.name {
            sourceNode = Upminster
        } else if sourceNode.name == UpminsterBridge.name {
            sourceNode = UpminsterBridge
        } else if sourceNode.name == Upney.name {
            sourceNode = Upney
        } else if sourceNode.name == UptonPark.name {
            sourceNode = UptonPark
        } else if sourceNode.name == Uxbridge.name {
            sourceNode = Uxbridge
        } else if sourceNode.name == Vauxhall.name {
            sourceNode = Vauxhall
        } else if sourceNode.name == Victoria.name {
            sourceNode = Victoria
        } else if sourceNode.name == WalthamstowCentral.name {
            sourceNode = WalthamstowCentral
        } else if sourceNode.name == Wanstead.name {
            sourceNode = Wanstead
        } else if sourceNode.name == Wapping.name {
            sourceNode = Wapping
        } else if sourceNode.name == WarrenStreet.name {
            sourceNode = WarrenStreet
        } else if sourceNode.name == WarwickAvenue.name {
            sourceNode = WarwickAvenue
        } else if sourceNode.name == Waterloo.name {
            sourceNode = Waterloo
        } else if sourceNode.name == Watford.name {
            sourceNode = Watford
        } else if sourceNode.name == WembleyCentral.name {
            sourceNode = WembleyCentral
        } else if sourceNode.name == WembleyPark.name {
            sourceNode = WembleyPark
        } else if sourceNode.name == WestActon.name {
            sourceNode = WestActon
        } else if sourceNode.name == WestBrompton.name {
            sourceNode = WestBrompton
        } else if sourceNode.name == WestFinchley.name {
            sourceNode = WestFinchley
        } else if sourceNode.name == WestHam.name {
            sourceNode = WestHam
        } else if sourceNode.name == WestHampstead.name {
            sourceNode = WestHampstead
        } else if sourceNode.name == WestHarrow.name {
            sourceNode = WestHarrow
        } else if sourceNode.name == WestIndiaQuay.name {
            sourceNode = WestIndiaQuay
        } else if sourceNode.name == WestKensington.name {
            sourceNode = WestKensington
        } else if sourceNode.name == WestRuislip.name {
            sourceNode = WestRuislip
        } else if sourceNode.name == WestbournePark.name {
            sourceNode = WestbournePark
        } else if sourceNode.name == Westferry.name {
            sourceNode = Westferry
        } else if sourceNode.name == Westminster.name {
            sourceNode = Westminster
        } else if sourceNode.name == WhiteCity.name {
            sourceNode = WhiteCity
        } else if sourceNode.name == Whitechapel.name {
            sourceNode = Whitechapel
        } else if sourceNode.name == WillesdenGreen.name {
            sourceNode = WillesdenGreen
        } else if sourceNode.name == WillesdenJunction.name {
            sourceNode = WillesdenJunction
        } else if sourceNode.name == Wimbledon.name {
            sourceNode = Wimbledon
        } else if sourceNode.name == WimbledonPark.name {
            sourceNode = WimbledonPark
        } else if sourceNode.name == WoodGreen.name {
            sourceNode = WoodGreen
        } else if sourceNode.name == Woodford.name {
            sourceNode = Woodford
        } else if sourceNode.name == WoodsidePark.name {
            sourceNode = WoodsidePark
        }
        
        
        
        
        
        
        //do the same for destination
        if destinationNode.name == ActonTown.name {
            destinationNode = ActonTown
        } else if destinationNode.name == Aldgate.name {
            destinationNode = Aldgate
        } else if destinationNode.name == AldgateEast.name {
            destinationNode = AldgateEast
        } else if destinationNode.name == AllSaints.name {
            destinationNode = AllSaints
        } else if destinationNode.name == Alperton.name {
            destinationNode = Alperton
        } else if destinationNode.name == Amersham.name {
            destinationNode = Amersham
        } else if destinationNode.name == Angel.name {
            destinationNode = Angel
        } else if destinationNode.name == Archway.name {
            destinationNode = Archway
        } else if destinationNode.name == ArnosGrove.name {
            destinationNode = ArnosGrove
        } else if destinationNode.name == Arsenal.name {
            destinationNode = Arsenal
        } else if destinationNode.name == BakerStreet.name {
            destinationNode = BakerStreet
        } else if destinationNode.name == Balham.name {
            destinationNode = Balham
        } else if destinationNode.name == Bank.name {
            destinationNode = Bank
        } else if destinationNode.name == Barbican.name {
            destinationNode = Barbican
        } else if destinationNode.name == Barking.name {
            destinationNode = Barking
        } else if destinationNode.name == Barkingside.name {
            destinationNode = Barkingside
        } else if destinationNode.name == BaronsCourt.name {
            destinationNode = BaronsCourt
        } else if destinationNode.name == Bayswater.name {
            destinationNode = Bayswater
        } else if destinationNode.name == Beckton.name {
            destinationNode = Beckton
        } else if destinationNode.name == BecktonPark.name {
            destinationNode = BecktonPark
        } else if destinationNode.name == Becontree.name {
            destinationNode = Becontree
        } else if destinationNode.name == BelsizePark.name {
            destinationNode = BelsizePark
        } else if destinationNode.name == Bermondsey.name {
            destinationNode = Bermondsey
        } else if destinationNode.name == BethnalGreen.name {
            destinationNode = BethnalGreen
        } else if destinationNode.name == Blackfriars.name {
            destinationNode = Blackfriars
        } else if destinationNode.name == BlackhorseRoad.name {
            destinationNode = BlackhorseRoad
        } else if destinationNode.name == Blackwall.name {
            destinationNode = Blackwall
        } else if destinationNode.name == BondStreet.name {
            destinationNode = BondStreet
        } else if destinationNode.name == Borough.name {
            destinationNode = Borough
        } else if destinationNode.name == BostonManor.name {
            destinationNode = BostonManor
        } else if destinationNode.name == BoundsGreen.name {
            destinationNode = BoundsGreen
        } else if destinationNode.name == BowChurch.name {
            destinationNode = BowChurch
        } else if destinationNode.name == BowRoad.name {
            destinationNode = BowRoad
        } else if destinationNode.name == BrentCross.name {
            destinationNode = BrentCross
        } else if destinationNode.name == Brixton.name {
            destinationNode = Brixton
        } else if destinationNode.name == BromleyByBow.name {
            destinationNode = BromleyByBow
        } else if destinationNode.name == BuckhurstHill.name {
            destinationNode = BuckhurstHill
        } else if destinationNode.name == BurntOak.name {
            destinationNode = BurntOak
        } else if destinationNode.name == CaledonianRoad.name {
            destinationNode = CaledonianRoad
        } else if destinationNode.name == CamdenTown.name {
            destinationNode = CamdenTown
        } else if destinationNode.name == CanadaWater.name {
            destinationNode = CanadaWater
        } else if destinationNode.name == CanaryWharf.name {
            destinationNode = CanaryWharf
        } else if destinationNode.name == CanningTown.name {
            destinationNode = CanningTown
        } else if destinationNode.name == CannonStreet.name {
            destinationNode = CannonStreet
        } else if destinationNode.name == CanonsPark.name {
            destinationNode = CanonsPark
        } else if destinationNode.name == ChalfrontAndLatimer.name {
            destinationNode = ChalfrontAndLatimer
        } else if destinationNode.name == ChalkFarm.name {
            destinationNode = ChalkFarm
        } else if destinationNode.name == ChanceryLane.name {
            destinationNode = ChanceryLane
        } else if destinationNode.name == CharingCross.name {
            destinationNode = CharingCross
        } else if destinationNode.name == Chesham.name {
            destinationNode = Chesham
        } else if destinationNode.name == Chigwell.name {
            destinationNode = Chigwell
        } else if destinationNode.name == ChiswickPark.name {
            destinationNode = ChiswickPark
        } else if destinationNode.name == Chorleywood.name {
            destinationNode = Chorleywood
        } else if destinationNode.name == ClaphamCommon.name {
            destinationNode = ClaphamCommon
        } else if destinationNode.name == ClaphamNorth.name {
            destinationNode = ClaphamNorth
        } else if destinationNode.name == ClaphamSouth.name {
            destinationNode = ClaphamSouth
        } else if destinationNode.name == Cockfosters.name {
            destinationNode = Cockfosters
        } else if destinationNode.name == Colindale.name {
            destinationNode = Colindale
        } else if destinationNode.name == ColliersWood.name {
            destinationNode = ColliersWood
        } else if destinationNode.name == CoventGarden.name {
            destinationNode = CoventGarden
        } else if destinationNode.name == CrossharbourAndLondonArena.name {
            destinationNode = CrossharbourAndLondonArena
        } else if destinationNode.name == Croxley.name {
            destinationNode = Croxley
        } else if destinationNode.name == CustomHouse.name {
            destinationNode = CustomHouse
        } else if destinationNode.name == CuttySark.name {
            destinationNode = CuttySark
        } else if destinationNode.name == Cyprus.name {
            destinationNode = Cyprus
        } else if destinationNode.name == DagenhamEast.name {
            destinationNode = DagenhamEast
        } else if destinationNode.name == DagenhamHeathway.name {
            destinationNode = DagenhamHeathway
        } else if destinationNode.name == Debden.name {
            destinationNode = Debden
        } else if destinationNode.name == DeptfordBridge.name {
            destinationNode = DeptfordBridge
        } else if destinationNode.name == DevonsRoad.name {
            destinationNode = DevonsRoad
        } else if destinationNode.name == DollisHill.name {
            destinationNode = DollisHill
        } else if destinationNode.name == EalingBroadway.name {
            destinationNode = EalingBroadway
        } else if destinationNode.name == EalingCommon.name {
            destinationNode = EalingCommon
        } else if destinationNode.name == EarlsCourt.name {
            destinationNode = EarlsCourt
        } else if destinationNode.name == EastActon.name {
            destinationNode = EastActon
        } else if destinationNode.name == EastFinchley.name {
            destinationNode = EastFinchley
        } else if destinationNode.name == EastHam.name {
            destinationNode = EastHam
        } else if destinationNode.name == EastIndia.name {
            destinationNode = EastIndia
        } else if destinationNode.name == EastPutney.name {
            destinationNode = EastPutney
        } else if destinationNode.name == Eastcote.name {
            destinationNode = Eastcote
        } else if destinationNode.name == Edgware.name {
            destinationNode = Edgware
        } else if destinationNode.name == EdgwareRoad.name {
            destinationNode = EdgwareRoad
        } else if destinationNode.name == ElephantAndCastle.name {
            destinationNode = ElephantAndCastle
        } else if destinationNode.name == ElmPark.name {
            destinationNode = ElmPark
        } else if destinationNode.name == ElversonRoad.name {
            destinationNode = ElversonRoad
        } else if destinationNode.name == Embankment.name {
            destinationNode = Embankment
        } else if destinationNode.name == Epping.name {
            destinationNode = Epping
        } else if destinationNode.name == Euston.name {
            destinationNode = Euston
        } else if destinationNode.name == EustonSquare.name {
            destinationNode = EustonSquare
        } else if destinationNode.name == Fairlop.name {
            destinationNode = Fairlop
        } else if destinationNode.name == Farringdon.name {
            destinationNode = Farringdon
        } else if destinationNode.name == FinchleyCentral.name {
            destinationNode = FinchleyCentral
        } else if destinationNode.name == FinchleyRoad.name {
            destinationNode = FinchleyRoad
        } else if destinationNode.name == FinsburyPark.name {
            destinationNode = FinsburyPark
        } else if destinationNode.name == FulhamBroadway.name {
            destinationNode = FulhamBroadway
        } else if destinationNode.name == GallionsReach.name {
            destinationNode = GallionsReach
        } else if destinationNode.name == GantsHill.name {
            destinationNode = GantsHill
        } else if destinationNode.name == GloucesterRoad.name {
            destinationNode = GloucesterRoad
        } else if destinationNode.name == GoldersGreen.name {
            destinationNode = GoldersGreen
        } else if destinationNode.name == GoldhawkRoad.name {
            destinationNode = GoldhawkRoad
        } else if destinationNode.name == GoodgeStreet.name {
            destinationNode = GoodgeStreet
        } else if destinationNode.name == GrangeHill.name {
            destinationNode = GrangeHill
        } else if destinationNode.name == GreatPortlandStreet.name {
            destinationNode = GreatPortlandStreet
        } else if destinationNode.name == GreenPark.name {
            destinationNode = GreenPark
        } else if destinationNode.name == Greenford.name {
            destinationNode = Greenford
        } else if destinationNode.name == Greenwich.name {
            destinationNode = Greenwich
        } else if destinationNode.name == Gunnersbury.name {
            destinationNode = Gunnersbury
        } else if destinationNode.name == Hainault.name {
            destinationNode = Hainault
        } else if destinationNode.name == Hammersmith.name {
            destinationNode = Hammersmith
        } else if destinationNode.name == Hampstead.name {
            destinationNode = Hampstead
        } else if destinationNode.name == HangerLane.name {
            destinationNode = HangerLane
        } else if destinationNode.name == Harlesden.name {
            destinationNode = Harlesden
        } else if destinationNode.name == HarrowAndWealdston.name {
            destinationNode = HarrowAndWealdston
        } else if destinationNode.name == HarrowOnTheHill.name {
            destinationNode = HarrowOnTheHill
        } else if destinationNode.name == HattonCross.name {
            destinationNode = HattonCross
        } else if destinationNode.name == HeathrowTerminal4.name {
            destinationNode = HeathrowTerminal4
        } else if destinationNode.name == HeathrowTerminal123.name {
            destinationNode = HeathrowTerminal123
        } else if destinationNode.name == HeathrowTerminal5.name {
            destinationNode = HeathrowTerminal5
        } else if destinationNode.name == HendonCentral.name {
            destinationNode = HendonCentral
        } else if destinationNode.name == HighBarnet.name {
            destinationNode = HighBarnet
        } else if destinationNode.name == HighStreetKensington.name {
            destinationNode = HighStreetKensington
        } else if destinationNode.name == HighburyAndIslington.name {
            destinationNode = HighburyAndIslington
        } else if destinationNode.name == Highgate.name {
            destinationNode = Highgate
        } else if destinationNode.name == Hillingdon.name {
            destinationNode = Hillingdon
        } else if destinationNode.name == Holborn.name {
            destinationNode = Holborn
        } else if destinationNode.name == HollandPark.name {
            destinationNode = HollandPark
        } else if destinationNode.name == HollowayRoad.name {
            destinationNode = HollowayRoad
        } else if destinationNode.name == Hornchurch.name {
            destinationNode = Hornchurch
        } else if destinationNode.name == HounslowCentral.name {
            destinationNode = HounslowCentral
        } else if destinationNode.name == HounslowEast.name {
            destinationNode = HounslowEast
        } else if destinationNode.name == HounslowWest.name {
            destinationNode = HounslowWest
        } else if destinationNode.name == HydeParkCorner.name {
            destinationNode = HydeParkCorner
        } else if destinationNode.name == Ickenham.name {
            destinationNode = Ickenham
        } else if destinationNode.name == IslandGardens.name {
            destinationNode = IslandGardens
        } else if destinationNode.name == Kennington.name {
            destinationNode = Kennington
        } else if destinationNode.name == KensalGreen.name {
            destinationNode = KensalGreen
        } else if destinationNode.name == KensintonOlympia.name {
            destinationNode = KensintonOlympia
        } else if destinationNode.name == KentishTown.name {
            destinationNode = KentishTown
        } else if destinationNode.name == Kenton.name {
            destinationNode = Kenton
        } else if destinationNode.name == KewGardens.name {
            destinationNode = KewGardens
        } else if destinationNode.name == Kilburn.name {
            destinationNode = Kilburn
        } else if destinationNode.name == KilburnPark.name {
            destinationNode = KilburnPark
        } else if destinationNode.name == KingsCross.name {
            destinationNode = KingsCross
        } else if destinationNode.name == Kingsbury.name {
            destinationNode = Kingsbury
        } else if destinationNode.name == Knightsbridge.name {
            destinationNode = Knightsbridge
        } else if destinationNode.name == LadbrokeGrove.name {
            destinationNode = LadbrokeGrove
        } else if destinationNode.name == LambethNorth.name {
            destinationNode = LambethNorth
        } else if destinationNode.name == LancasterGate.name {
            destinationNode = LancasterGate
        } else if destinationNode.name == LatimerRoad.name {
            destinationNode = LatimerRoad
        } else if destinationNode.name == LeicesterSquare.name {
            destinationNode = LeicesterSquare
        } else if destinationNode.name == Lewisham.name {
            destinationNode = Lewisham
        } else if destinationNode.name == Leyton.name {
            destinationNode = Leyton
        } else if destinationNode.name == Leytonstone.name {
            destinationNode = Leytonstone
        } else if destinationNode.name == Limehouse.name {
            destinationNode = Limehouse
        } else if destinationNode.name == LiverpoolStreet.name {
            destinationNode = LiverpoolStreet
        } else if destinationNode.name == LondonBridge.name {
            destinationNode = LondonBridge
        } else if destinationNode.name == Loughton.name {
            destinationNode = Loughton
        } else if destinationNode.name == MaidaVale.name {
            destinationNode = MaidaVale
        } else if destinationNode.name == ManorHouse.name {
            destinationNode = ManorHouse
        } else if destinationNode.name == MansionHouse.name {
            destinationNode = MansionHouse
        } else if destinationNode.name == MarbleArch.name {
            destinationNode = MarbleArch
        } else if destinationNode.name == Marylebone.name {
            destinationNode = Marylebone
        } else if destinationNode.name == MileEnd.name {
            destinationNode = MileEnd
        } else if destinationNode.name == MillHillEast.name {
            destinationNode = MillHillEast
        } else if destinationNode.name == Monument.name {
            destinationNode = Monument
        } else if destinationNode.name == MoorPark.name {
            destinationNode = MoorPark
        } else if destinationNode.name == Moorgate.name {
            destinationNode = Moorgate
        } else if destinationNode.name == Morden.name {
            destinationNode = Morden
        } else if destinationNode.name == MorningtonCresent.name {
            destinationNode = MorningtonCresent
        } else if destinationNode.name == Mudchute.name {
            destinationNode = Mudchute
        } else if destinationNode.name == Neasden.name {
            destinationNode = Neasden
        } else if destinationNode.name == NewCross.name {
            destinationNode = NewCross
        } else if destinationNode.name == NewCrossGate.name {
            destinationNode = NewCrossGate
        } else if destinationNode.name == NewburyPark.name {
            destinationNode = NewburyPark
        } else if destinationNode.name == NorthActon.name {
            destinationNode = NorthActon
        } else if destinationNode.name == NorthEaling.name {
            destinationNode = NorthEaling
        } else if destinationNode.name == NorthGreenwich.name {
            destinationNode = NorthGreenwich
        } else if destinationNode.name == NorthHarrow.name {
            destinationNode = NorthHarrow
        } else if destinationNode.name == NorthWembley.name {
            destinationNode = NorthWembley
        } else if destinationNode.name == Northfields.name {
            destinationNode = Northfields
        } else if destinationNode.name == Northolt.name {
            destinationNode = Northolt
        } else if destinationNode.name == NorthwickPark.name {
            destinationNode = NorthwickPark
        } else if destinationNode.name == Northwood.name {
            destinationNode = Northwood
        } else if destinationNode.name == NorthwoodHills.name {
            destinationNode = NorthwoodHills
        } else if destinationNode.name == NottingHillGate.name {
            destinationNode = NottingHillGate
        } else if destinationNode.name == Oakwood.name {
            destinationNode = Oakwood
        } else if destinationNode.name == OldStreet.name {
            destinationNode = OldStreet
        } else if destinationNode.name == Osterley.name {
            destinationNode = Osterley
        } else if destinationNode.name == Oval.name {
            destinationNode = Oval
        } else if destinationNode.name == OxfordCircus.name {
            destinationNode = OxfordCircus
        } else if destinationNode.name == Paddington.name {
            destinationNode = Paddington
        } else if destinationNode.name == ParkRoyal.name {
            destinationNode = ParkRoyal
        } else if destinationNode.name == ParsonsGreen.name {
            destinationNode = ParsonsGreen
        } else if destinationNode.name == Perivale.name {
            destinationNode = Perivale
        } else if destinationNode.name == PicadillyCircus.name {
            destinationNode = PicadillyCircus
        } else if destinationNode.name == Pimlico.name {
            destinationNode = Pimlico
        } else if destinationNode.name == Pinner.name {
            destinationNode = Pinner
        } else if destinationNode.name == Plaistow.name {
            destinationNode = Plaistow
        } else if destinationNode.name == Poplar.name {
            destinationNode = Poplar
        } else if destinationNode.name == PrestonRoad.name {
            destinationNode = PrestonRoad
        } else if destinationNode.name == PrinceRegent.name {
            destinationNode = PrinceRegent
        } else if destinationNode.name == PuddingMillLane.name {
            destinationNode = PuddingMillLane
        } else if destinationNode.name == PutneyBridge.name {
            destinationNode = PutneyBridge
        } else if destinationNode.name == QueensPark.name {
            destinationNode = QueensPark
        } else if destinationNode.name == Queensbury.name {
            destinationNode = Queensbury
        } else if destinationNode.name == Queensway.name {
            destinationNode = Queensway
        } else if destinationNode.name == RavenscourtPark.name {
            destinationNode = RavenscourtPark
        } else if destinationNode.name == RaynersLane.name {
            destinationNode = RaynersLane
        } else if destinationNode.name == Redbridge.name {
            destinationNode = Redbridge
        } else if destinationNode.name == RegentsPark.name {
            destinationNode = RegentsPark
        } else if destinationNode.name == Richmond.name {
            destinationNode = Richmond
        } else if destinationNode.name == Rickmansworth.name {
            destinationNode = Rickmansworth
        } else if destinationNode.name == RodingValley.name {
            destinationNode = RodingValley
        } else if destinationNode.name == Rotherhithe.name {
            destinationNode = Rotherhithe
        } else if destinationNode.name == RoyalAlbert.name {
            destinationNode = RoyalAlbert
        } else if destinationNode.name == RoyalOak.name {
            destinationNode = RoyalOak
        } else if destinationNode.name == RoyalVictoria.name {
            destinationNode = RoyalVictoria
        } else if destinationNode.name == Ruislip.name {
            destinationNode = Ruislip
        } else if destinationNode.name == RuislipGardens.name {
            destinationNode = RuislipGardens
        } else if destinationNode.name == RuislipManor.name {
            destinationNode = RuislipManor
        } else if destinationNode.name == RussellSquare.name {
            destinationNode = RussellSquare
        } else if destinationNode.name == SevenSisters.name {
            destinationNode = SevenSisters
        } else if destinationNode.name == Shadwell.name {
            destinationNode = Shadwell
        } else if destinationNode.name == ShephardsBush.name {
            destinationNode = ShephardsBush
        } else if destinationNode.name == Shoreditch.name {
            destinationNode = Shoreditch
        } else if destinationNode.name == SloaneSquare.name {
            destinationNode = SloaneSquare
        } else if destinationNode.name == Snaresbrook.name {
            destinationNode = Snaresbrook
        } else if destinationNode.name == SouthEaling.name {
            destinationNode = SouthEaling
        } else if destinationNode.name == SouthHarrow.name {
            destinationNode = SouthHarrow
        } else if destinationNode.name == SouthKensington.name {
            destinationNode = SouthKensington
        } else if destinationNode.name == SouthKenton.name {
            destinationNode = SouthKenton
        } else if destinationNode.name == SouthQuays.name {
            destinationNode = SouthQuays
        } else if destinationNode.name == SouthRuislip.name {
            destinationNode = SouthRuislip
        } else if destinationNode.name == SouthWimbledon.name {
            destinationNode = SouthWimbledon
        } else if destinationNode.name == SouthWoodford.name {
            destinationNode = SouthWoodford
        } else if destinationNode.name == Southfields.name {
            destinationNode = Southfields
        } else if destinationNode.name == Southgate.name {
            destinationNode = Southgate
        } else if destinationNode.name == Southwark.name {
            destinationNode = Southwark
        } else if destinationNode.name == StJamesPark.name {
            destinationNode = StJamesPark
        } else if destinationNode.name == StJohnsWood.name {
            destinationNode = StJohnsWood
        } else if destinationNode.name == StPauls.name {
            destinationNode = StPauls
        } else if destinationNode.name == StamfordBrook.name {
            destinationNode = StamfordBrook
        } else if destinationNode.name == Stanmore.name {
            destinationNode = Stanmore
        } else if destinationNode.name == StephneyGreen.name {
            destinationNode = StephneyGreen
        } else if destinationNode.name == Stockwell.name {
            destinationNode = Stockwell
        } else if destinationNode.name == StonebridgePark.name {
            destinationNode = StonebridgePark
        } else if destinationNode.name == Stratford.name {
            destinationNode = Stratford
        } else if destinationNode.name == SudburyHill.name {
            destinationNode = SudburyHill
        } else if destinationNode.name == SudburyTown.name {
            destinationNode = SudburyTown
        } else if destinationNode.name == SurreyQuays.name {
            destinationNode = SurreyQuays
        } else if destinationNode.name == SwissCottage.name {
            destinationNode = SwissCottage
        } else if destinationNode.name == Temple.name {
            destinationNode = Temple
        } else if destinationNode.name == TheydonBois.name {
            destinationNode = TheydonBois
        } else if destinationNode.name == TootingBec.name {
            destinationNode = TootingBec
        } else if destinationNode.name == TootingBroadway.name {
            destinationNode = TootingBroadway
        } else if destinationNode.name == TottenhamCourtRoad.name {
            destinationNode = TottenhamCourtRoad
        } else if destinationNode.name == TottenhamHale.name {
            destinationNode = TottenhamHale
        } else if destinationNode.name == TotteridgeAndWhetstone.name {
            destinationNode = TotteridgeAndWhetstone
        } else if destinationNode.name == TowerGateway.name {
            destinationNode = TowerGateway
        } else if destinationNode.name == TowerHill.name {
            destinationNode = TowerHill
        } else if destinationNode.name == TufnellPark.name {
            destinationNode = TufnellPark
        } else if destinationNode.name == TurnhamGreen.name {
            destinationNode = TurnhamGreen
        } else if destinationNode.name == TurnpikeLane.name {
            destinationNode = TurnpikeLane
        } else if destinationNode.name == Upminster.name {
            destinationNode = Upminster
        } else if destinationNode.name == UpminsterBridge.name {
            destinationNode = UpminsterBridge
        } else if destinationNode.name == Upney.name {
            destinationNode = Upney
        } else if destinationNode.name == UptonPark.name {
            destinationNode = UptonPark
        } else if destinationNode.name == Uxbridge.name {
            destinationNode = Uxbridge
        } else if destinationNode.name == Vauxhall.name {
            destinationNode = Vauxhall
        } else if destinationNode.name == Victoria.name {
            destinationNode = Victoria
        } else if destinationNode.name == WalthamstowCentral.name {
            destinationNode = WalthamstowCentral
        } else if destinationNode.name == Wanstead.name {
            destinationNode = Wanstead
        } else if destinationNode.name == Wapping.name {
            destinationNode = Wapping
        } else if destinationNode.name == WarrenStreet.name {
            destinationNode = WarrenStreet
        } else if destinationNode.name == WarwickAvenue.name {
            destinationNode = WarwickAvenue
        } else if destinationNode.name == Waterloo.name {
            destinationNode = Waterloo
        } else if destinationNode.name == Watford.name {
            destinationNode = Watford
        } else if destinationNode.name == WembleyCentral.name {
            destinationNode = WembleyCentral
        } else if destinationNode.name == WembleyPark.name {
            destinationNode = WembleyPark
        } else if destinationNode.name == WestActon.name {
            destinationNode = WestActon
        } else if destinationNode.name == WestBrompton.name {
            destinationNode = WestBrompton
        } else if destinationNode.name == WestFinchley.name {
            destinationNode = WestFinchley
        } else if destinationNode.name == WestHam.name {
            destinationNode = WestHam
        } else if destinationNode.name == WestHampstead.name {
            destinationNode = WestHampstead
        } else if destinationNode.name == WestHarrow.name {
            destinationNode = WestHarrow
        } else if destinationNode.name == WestIndiaQuay.name {
            destinationNode = WestIndiaQuay
        } else if destinationNode.name == WestKensington.name {
            destinationNode = WestKensington
        } else if destinationNode.name == WestRuislip.name {
            destinationNode = WestRuislip
        } else if destinationNode.name == WestbournePark.name {
            destinationNode = WestbournePark
        } else if destinationNode.name == Westferry.name {
            destinationNode = Westferry
        } else if destinationNode.name == Westminster.name {
            destinationNode = Westminster
        } else if destinationNode.name == WhiteCity.name {
            destinationNode = WhiteCity
        } else if destinationNode.name == Whitechapel.name {
            destinationNode = Whitechapel
        } else if destinationNode.name == WillesdenGreen.name {
            destinationNode = WillesdenGreen
        } else if destinationNode.name == WillesdenJunction.name {
            destinationNode = WillesdenJunction
        } else if destinationNode.name == Wimbledon.name {
            destinationNode = Wimbledon
        } else if destinationNode.name == WimbledonPark.name {
            destinationNode = WimbledonPark
        } else if destinationNode.name == WoodGreen.name {
            destinationNode = WoodGreen
        } else if destinationNode.name == Woodford.name {
            destinationNode = Woodford
        } else if destinationNode.name == WoodsidePark.name {
            destinationNode = WoodsidePark
        }
        
    }
    
    
}

extension UIViewController{
    
    func HideKeyboard(){
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
}

extension JPViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allStations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return allStations[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        checkNode()
        
        if pickerView == fromPickeview {
            fromLabel.text = allStations[row]
            sourceNode.name = fromLabel.text!
        } else {
            toLabel.text = allStations[row]
            destinationNode.name = toLabel.text!
        }
        
    }
    
    
}
