class Ids {
  static const String titleSoft = 'title_soft';
  static const String titleGame = 'title_game';
}

Map<String, Map<String, String>> localizedSimpleValues = {
  'en': {
    Ids.titleSoft: 'Game',
    Ids.titleGame: 'Soft',
  },
  'zh': {
    Ids.titleSoft: '软件',
    Ids.titleGame: '游戏',
  },
};

Map<String, Map<String, Map<String, String>>> localizedValues = {
  'en': {
    'US': {
      Ids.titleSoft: 'Game',
      Ids.titleGame: 'Soft',
    }
  },
  'zh': {
    'CN': {
      Ids.titleSoft: '软件',
      Ids.titleGame: '游戏',
    },
    'HK': {
      Ids.titleSoft: '軟件',
      Ids.titleGame: '遊戲',
    },
    'TW': {
      Ids.titleSoft: '軟件',
      Ids.titleGame: '遊戲',
    }
  }
};
