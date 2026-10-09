import 'dart:math';
import 'rpg_game.dart';

enum SuperAbility { criticalDamage, boost, heal, blockRevert, dodge, sacrifice, stun }

abstract class GameCharacter {
  int _health;
  int damage;
  String name;

  GameCharacter(this._health, this.damage, this.name);

  int get health => _health;

  set health(int value) {
    if (value < 0) {
      _health = 0;
    } else {
      _health = value;
    }
  }

  bool isAlive() {
    return health > 0;
  }

  @override
  String toString() {
    return '${runtimeType.toString()} $name health: $health damage: $damage';
  }
}

class Boss extends GameCharacter {
  SuperAbility? defence;
  bool isStunned = false; 

  Boss(super.health, super.damage, super.name);

  void chooseDefence() {
    List<SuperAbility> variants = SuperAbility.values;
    Random random = Random();
    int randomIndex = random.nextInt(4); 
    defence = variants[randomIndex];
  }

  void attack(List<Hero> heroes) {
    Golem? golem; 

    for (Hero h in heroes) {
      if (h is Golem && h.isAlive()) {
        golem = h;
        break;
      }
    }

    for (Hero h in heroes) {
      if (h.isAlive()) {
        if (h is Golem) {
          continue; 
        }

        if (h is Lucky) {
          if (RpgGame.random.nextInt(100) < 25) {
            print('Lucky ${h.name} dodged the attack!');
            continue; 
          }
        }

        int finalDamage = damage;
        if (h is Berserk && defence != SuperAbility.blockRevert) {
          h.blockedDamage = 10;
          finalDamage -= h.blockedDamage;
        }

        if (golem != null && golem.isAlive()) {
          int sharedDamage = finalDamage ~/ 5;
          finalDamage -= sharedDamage;
          
          (golem as Golem).health -= sharedDamage;
          
          if (!golem.isAlive()) {
            golem = null; 
          }
        }

        h.health -= finalDamage;
      }
    }

    for (Hero h in heroes) {
      if (h is Golem && h.isAlive()) {
        h.health -= damage;
      }
    }
  }

  @override
  String toString() {
    return '${super.toString()} defence: $defence';
  }
}

abstract class Hero extends GameCharacter {
  SuperAbility ability;
  Hero(super.health, super.damage, super.name, this.ability);
  void attack(Boss boss) {
    boss.health -= damage;
  }
  void applySuperPower(Boss boss, List<Hero> heroes);
}

class Warrior extends Hero {
  Warrior(int health, int damage, String name)
    : super(health, damage, name, SuperAbility.criticalDamage);
  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    Random random = Random();
    int crit = damage * (random.nextInt(5) + 2); 
    boss.health -= crit;
    print('Warrior $name hit critically $crit');
  }
}

class Magic extends Hero {
  Magic(int health, int damage, String name)
    : super(health, damage, name, SuperAbility.boost);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    if (RpgGame.roundNumber <= 4) {
      int boostValue = 5; 
      for (Hero h in heroes) {
        if (h.isAlive() && h != this) {
          h.damage += boostValue;
        }
      }
      print('Magic $name boosted team damage by $boostValue');
    }
  }
}

class Medic extends Hero {
  int healPoints;
  Medic(int health, int damage, String name, this.healPoints)
    : super(health, damage, name, SuperAbility.heal);
  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    for (Hero h in heroes) {
      if (h.isAlive() && h != this) {
        h.health += healPoints;
      }
    }
  }
}

class Berserk extends Hero {
  int blockedDamage = 0;
  Berserk(int health, int damage, String name)
    : super(health, damage, name, SuperAbility.blockRevert);
  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    print('Berserk $name reverted $blockedDamage');
    boss.health -= blockedDamage;
  }
}

class Golem extends Hero {
  Golem(int health, int damage, String name) 
    : super(health, damage, name, SuperAbility.blockRevert);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {}
}

class Lucky extends Hero {
  Lucky(int health, int damage, String name) 
    : super(health, damage, name, SuperAbility.dodge);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {}
}

class Witcher extends Hero {
  bool hasResurrected = false;

  Witcher(int health, int damage, String name) 
    : super(health, 0, name, SuperAbility.sacrifice); 

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    if (isAlive() && !hasResurrected) {
      for (Hero h in heroes) {
        if (!h.isAlive() && h != this) {
          h.health = this.health;
          this.health = 0; 
          hasResurrected = true;
          print('Witcher $name sacrificed himself to resurrect ${h.name}');
          break;
        }
      }
    }
  }
}

class Thor extends Hero {
  Thor(int health, int damage, String name) 
    : super(health, damage, name, SuperAbility.stun);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    if (RpgGame.random.nextBool()) { 
      boss.isStunned = true;
      print('Thor $name stunned the boss!');
    }
  }
}

class Ludoman extends Hero {
  Ludoman(int health, int damage, String name) 
    : super(health, damage, name, SuperAbility.criticalDamage);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    if (!isAlive()) return;

    int dice1 = RpgGame.random.nextInt(6) + 1;
    int dice2 = RpgGame.random.nextInt(6) + 1;
    
    print('Ludoman $name rolled dice: [$dice1] and [$dice2]');

    if (dice1 == dice2) {
      int product = dice1 * dice2;
      boss.health -= product;
      print('🎰 SUCCESS! Ludoman $name hit the Boss for $product damage!');
    } else {
      List<Hero> aliveTeammates = heroes.where((h) => h.isAlive() && h != this).toList();
      
      if (aliveTeammates.isNotEmpty) {
        int sum = dice1 + dice2;
        int randomIndex = RpgGame.random.nextInt(aliveTeammates.length);
        Hero victim = aliveTeammates[randomIndex];
        
        victim.health -= sum;
        print('🎲 LUDOMANIA! Ludoman $name hit teammate ${victim.name} for $sum damage!');
      }
    }
  }
}