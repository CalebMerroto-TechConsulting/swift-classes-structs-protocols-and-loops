protocol Person {
    var name: String { get }
    var species: String { get }
    
    func say(_ thing: String)
}

struct Jedi: Person {
    var name: String
    var species: String
    var master: [Jedi]?
    var rank: String
    var lightsaberColors: [String]
    var currentPadawans: [Jedi] = []
    var pastPadawans: [Jedi] = []
    var hasPassedTrial: Bool = true
    
    
    lazy var lightsaberCount: Int = lightsaberColors.count
    
    var fullTitle: String {
        return "\(rank) \(name)"
    }

    
    func say(_ thing: String) {
        print("\(fullTitle): \"\(thing)\"")
    }
    
    var canRankUp: Bool {
        switch rank {
        case "Padawan":
            return hasPassedTrial
        case "Knight":
            return pastPadawans.count >= 1
        case "Master":
            return pastPadawans.count >= 2
        case "Counselor":
            return false
        case "Master of the Order":
            return false
        default:
            return false
        }
    }
    
    mutating func attemptTrial() {
        if rank == "Padawan" {
            if hasPassedTrial {
                print("\(name) has already passed the trial.")
            }
            else {
                var attempt = Int.random(in: 1...10)
                if attempt == 1 {
                    hasPassedTrial = true
                    print("\(name) passed their trials!")
                }
                else {
                    print("\(name) failed their trials.")
                }
            }
        }
    }
    
    mutating func rankUp() {
        if canRankUp {
            switch rank {
            case "Padawan":
                rank = "Knight"
            case "Knight":
                rank = "Master"
            case "Master":
                rank = "Counselor"
            case "Counselor":
                rank = "Master of the Order"
            default:
                print("\(name) has reached the highest rank.")
            }
        } else {
            print("\(name) is not eligible to rank up.")
        }
    }

    mutating func takePadawan(_ padawan: Jedi) {
        if padawan.rank != "Padawan" {
            print("\(padawan.name) is not a padawan, and thus cannot be taken as an apprentice.")
            return
        }
        if rank != "Padawan" {
            currentPadawans.append(padawan)
            print("\(name) has taken \(padawan.name) as a Padawan.")
        } else {
            print("\(name) is not high enough in rank to take a Padawan.")
        }
    }

    mutating func graduatePadawan(_ padawan: inout Jedi) {
        if let index = currentPadawans.firstIndex(where: { $0.name == padawan.name }) {
            if padawan.canRankUp {
                padawan.rankUp()
                currentPadawans.remove(at: index)
                pastPadawans.append(padawan)
                print("\(padawan.name) has graduated to the rank of \(padawan.rank).")
            } else {
                print("\(padawan.name) has not completed their trials and thus cannot rank up.")
            }
        } else {
            print("\(padawan.name) is not a current Padawan of \(name).")
        }
    }
    
    mutating func displayInfo() {
        print("Jedi: \(name)")
        print("Species: \(species)")
        print("Master: \(master?[0].name ?? "N/A")")
        print("Rank: \(rank)")
        print("Lightsaber(s): \(lightsaberColors.joined(separator: ", ")) (\(lightsaberCount) total)")
        
        if !currentPadawans.isEmpty {
            print("Current Padawans: \(currentPadawans.map { $0.name }.joined(separator: ", "))")
        }
        if !pastPadawans.isEmpty {
            print("Past Padawans: \(pastPadawans.map { $0.name }.joined(separator: ", "))")
        }
        print("\n")
    }
}

class Senator: Person {
    var name: String
    var species: String
    var planet: String
    private var policies: [String]

    init(name: String, species: String, planet: String, policies: [String]) {
        self.name = name
        self.species = species
        self.planet = planet
        self.policies = policies
    }
    
    func say(_ thing: String) {
        print("\(name) of \(planet): \"\(thing)\"")
    }

    func getPolicies() -> [String] {
        return policies
    }

    func addPolicy(_ policy: String) {
        policies.append(policy)
    }
    
    func listSenatePolicies(_ senator: Senator) {
        let policies = senator.getPolicies()
        for policy in policies {
            print("\(name) - \(policy)")
        }
    }
    
}
class Chancellor: Senator {
    override func say(_ thing: String) {
        print("Chancellor \(name): \"\(thing)\"")
    }
}

extension Senator {
    func shadyDeal(with otherSenator: Senator, deal: String) {
        print("\(name) has made a secret deal with \(otherSenator.name).")
        print("Deal Details: \(deal)")
        
        // Simulate a bribe or backroom agreement
        addPolicy("Private Agreement with \(otherSenator.name)")
        otherSenator.addPolicy("Private Agreement with \(name)")
        
        print("The Senate remains unaware of this transaction...")
    }
}
// ====== TEST CASES ======
print("\n========= JEDI TEST CASES =========")

// Create Jedi Masters
var yoda = Jedi(name: "Yoda", species: "Unknown", master: nil, rank: "Grand Master", lightsaberColors: ["Green"])
var obiWan = Jedi(name: "Obi-Wan Kenobi", species: "Human", master: [yoda], rank: "Master", lightsaberColors: ["Blue"])
var anakin = Jedi(name: "Anakin Skywalker", species: "Human", master: [obiWan], rank: "Padawan", lightsaberColors: ["Blue"])
var ahsoka = Jedi(name: "Ahsoka Tano", species: "Togruta", master: [anakin], rank: "Padawan", lightsaberColors: ["Green"])

// Jedi Display Info
print("\n--- Jedi Information ---")
yoda.displayInfo()
obiWan.displayInfo()
anakin.displayInfo()

// Obi-Wan takes Anakin as a Padawan
print("\n--- Taking Padawans ---")
obiWan.takePadawan(anakin)
print("\n")
// Anakin Repeats Trial Until Passed
while !anakin.canRankUp {
    anakin.attemptTrial()
    print("\n")
}
obiWan.graduatePadawan(&anakin)
anakin.displayInfo()
print("\n")

// Anakin trains Ahsoka as his first Padawan
ahsoka.displayInfo()
print("\n")
anakin.takePadawan(ahsoka)

// Ahsoka Repeats Trial Until Passed
repeat {
    ahsoka.attemptTrial()
    anakin.graduatePadawan(&ahsoka)
    print("\n")
} while  !ahsoka.hasPassedTrial

// Jedi Say Something
print("\n--- Jedi Quotes ---")
yoda.say("Destroy the Sith we must.")
anakin.say("I hate sand.")



print("\n========= SENATE TEST CASES =========")

// Create Senators
let BailOrgana = Senator(name: "Bail Organa", species: "Human", planet: "Alderaan", policies: ["Support Democracy"])
let ShevePalpatine = Chancellor(name: "Palpatine", species: "Human", planet: "Naboo", policies: ["Emergency Powers"])
let PadmeAmidala = Senator(name: "Padmé Amidala", species: "Human", planet: "Naboo", policies: ["Peaceful Negotiations"])
let NuteGunray = Senator(name: "Nute Gunray", species: "Neimoidian", planet: "Cato Neimoidia", policies: ["Trade Federation Control"])

// Politicians Say Something
print("\n--- Political Speeches ---")
BailOrgana.say("The Republic must stand strong!")
PadmeAmidala.say("Diplomacy must be our first choice.")
ShevePalpatine.say("I am the Senate!")
NuteGunray.say("We demand control over the trade routes!")

// Adding Policies
print("\n--- Adding Policies ---")
BailOrgana.addPolicy("Trade Regulation")
PadmeAmidala.addPolicy("Protection of Republic Planets")
NuteGunray.addPolicy("Exclusive Droid Production Rights")
ShevePalpatine.addPolicy("Unlimited Power")

// Listing Policies
print("\n--- Senate Policies ---")
BailOrgana.listSenatePolicies(BailOrgana)
PadmeAmidala.listSenatePolicies(PadmeAmidala)
ShevePalpatine.listSenatePolicies(ShevePalpatine)
NuteGunray.listSenatePolicies(NuteGunray)

// Secret Shady Deal
print("\n--- Shady Deals ---")
ShevePalpatine.shadyDeal(with: NuteGunray, deal: "Trade Federation grants control of droid armies in exchange for Sith influence.")

// Verify Shady Deal Was Recorded
print("\n--- Updated Senate Policies ---")
BailOrgana.listSenatePolicies(BailOrgana)
PadmeAmidala.listSenatePolicies(PadmeAmidala)
ShevePalpatine.listSenatePolicies(ShevePalpatine)
NuteGunray.listSenatePolicies(NuteGunray)
