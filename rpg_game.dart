import 'dart:math';
import 'game_characters.dart';

class RpgGame {
  static int roundNumber = 0;
  static final Random random = Random(); 

  static void startGame() {
    Boss boss = Boss(1500, 50, 'Dragon');
    Warrior warrior1 = Warrior(280, 10, 'Leon');
    Warrior warrior2 = Warrior(270, 15, 'Ahiles');
    Medic doc = Medic(250, 5, 'Aibolit', 15);
    Medic assistant = Medic(300, 5, 'Max', 5);
    Berserk berserk = Berserk(260, 10, 'Alex');
    Magic magic = Magic(290, 10, 'Strange');
    

    Golem golem = Golem(450, 5, 'Rock');
    Lucky lucky = Lucky(240, 12, 'Clover');
    Witcher witcher = Witcher(250, 0, 'Geralt');
    Thor thor = Thor(260, 15, 'Odin');

    List<Hero> heroes = [
      warrior1, doc, berserk, assistant, magic, warrior2, 
      golem, lucky, witcher, thor
    ];
    
    printStatistics(boss, heroes);

    while (!isGameOver(boss, heroes)) {
      playRound(boss, heroes);
    }
  }

  static void printStatistics(Boss boss, List<Hero> heroes) {
    print('ROUND $roundNumber ----------------');
    print(boss);
    for (Hero h in heroes) {
      print(h);
    }
  }

  static void playRound(Boss boss, List<Hero> heroes) {
    roundNumber++;
    boss.chooseDefence();
    
    if (boss.isStunned) {
      print('The Boss is STUNNED and skips this round!');
      boss.isStunned = false; 
    } else {
      boss.attack(heroes);
    }

    for (Hero h in heroes) {
      if (h.isAlive() && boss.isAlive() && h.ability != boss.defence) {
        h.attack(boss);
        h.applySuperPower(boss, heroes);
      }
    }
    printStatistics(boss, heroes);
  }

  static bool isGameOver(Boss boss, List<Hero> heroes) {
    if (!boss.isAlive()) {
      print('Heroes won!!!');
      return true;
    }
    bool allHeroesDead = true;
    for (Hero h in heroes) {
      if (h.isAlive()) {
        allHeroesDead = false;
        break;
      }
    }
    if (allHeroesDead) {
      print('Boss won!!!');
      return true;
    }
    return false;
  }
}