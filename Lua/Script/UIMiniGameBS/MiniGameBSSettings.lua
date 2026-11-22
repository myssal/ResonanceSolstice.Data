local Config = {
  path = "UI/Activity/ActivityWorldBoss/MiniGameBS/",
  text = {
    mary = 80612947,
    livia = 80612948,
    interact = 80612949,
    gateInteract = 80612950,
    approach = 80612951,
    gateApproach = 80612952,
    emptyGarden = 80612953,
    rankUnavailable = 80612954,
    rankError = 80612955
  },
  dialogue = {
    gate = {
      speaker = "mary",
      ids = {
        80612927,
        80612928,
        80612929
      },
      soundIds = {
        {
          30008263,
          30008264,
          30008265,
          30008266
        },
        {
          30008267,
          30008268,
          30008269
        },
        {30008270, 30008271}
      }
    },
    opening = {
      speaker = "mary",
      ids = {80612930},
      soundIds = {
        {
          30008272,
          30008273,
          30008274
        }
      }
    },
    reaction = {
      speaker = "mary",
      ids = {80612931},
      soundIds = {0}
    },
    kill = {
      speaker = "mary",
      ids = {80612932, 80612933},
      soundIds = {
        30008288,
        {
          30008289,
          30008290,
          30008291
        }
      }
    },
    blocked = {
      speaker = "livia",
      ids = {80612934},
      soundIds = {0}
    },
    ending = {
      ids = {80612935},
      soundIds = {0}
    }
  },
  impactSoundIds = {
    30008275,
    30008276,
    30008277,
    30008278,
    30008279,
    30008280,
    30008281,
    30008282,
    30008292,
    30008293,
    30008294,
    30008295
  },
  rank = {minimumRows = 10},
  typingInterval = 0.028,
  speed = 85,
  radius = 6,
  footOffset = 70,
  bounds = {
    -120,
    121,
    140,
    544
  },
  obstacles = {
    {
      -126,
      361,
      -29,
      453
    },
    {
      30,
      361,
      127,
      453
    },
    {
      -116,
      148,
      -96,
      160
    },
    {
      97,
      150,
      117,
      162
    },
    {
      -116,
      241,
      -96,
      253
    },
    {
      97,
      241,
      117,
      253
    },
    {
      -116,
      332,
      -96,
      344
    },
    {
      97,
      336,
      117,
      348
    },
    {
      -39,
      0,
      39,
      179
    }
  },
  gateRect = {
    -29,
    362,
    30,
    505
  },
  gatePoint = {1, 498},
  gateRadius = 54,
  npcPoint = {0, 174},
  npcRadius = 39,
  walkFrame = 0.08,
  maryFrame = 0.1
}
return Config
