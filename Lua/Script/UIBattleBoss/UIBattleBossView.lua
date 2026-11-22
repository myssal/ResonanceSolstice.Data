local BattleBoss = {
  self = nil,
  Img_Bg = nil,
  Img_Top = nil,
  ScrollGrid_LevelList = {
    self = nil,
    grid = {
      self = nil,
      Group_Off = {self = nil, Img_Bg = nil},
      Group_On = {
        self = nil,
        Img_Bg = nil,
        Img_Mask = {
          self = nil,
          Img_Icon = nil,
          Txt_T = nil
        }
      },
      Group_Lock = {self = nil, Img_Bg = nil},
      Img_HeadMask = {
        self = nil,
        Spine_Head = nil,
        Img_Head = nil
      },
      Img_OffMask = {
        self = nil,
        Img_Icon = nil,
        Txt_T = nil
      },
      Img_LockMask = {
        self = nil,
        Img_Lock = nil,
        Txt_Lv = nil
      },
      Txt_Progress = nil,
      Img_Select = nil,
      Btn_Select = nil
    }
  },
  Group_Right = {
    self = nil,
    Img_Bottom = {self = nil, Img_Text = nil},
    Group_Title = {
      self = nil,
      Btn_Mechanism = {
        self = nil,
        Txt_T = nil,
        Img_Icon = nil
      },
      Txt_Text = nil,
      Group_Stage = {
        self = nil,
        Img_Bg = nil,
        Group_Bar = {
          self = nil,
          Img_Bar000 = nil,
          Img_Bar001 = nil,
          Img_Bar002 = nil,
          Img_Bar003 = nil,
          Img_Bar004 = nil
        }
      },
      Txt_Index = nil,
      Img_Camp = nil,
      Txt_Progress = nil,
      UI_ActivityBattleBoss_index = {
        self = nil,
        ref = nil,
        Line = nil
      }
    },
    Group_Des = {
      self = nil,
      Txt_T = nil,
      Txt_Desc = nil
    },
    Group_Drop = {
      self = nil,
      Img_BG = nil,
      Txt_Title = nil,
      Txt_TitleE = nil,
      ScrollGrid_Item = {
        self = nil,
        grid = {
          self = nil,
          Group_Item = {
            self = nil,
            Btn_Item = nil,
            Img_Bottom = nil,
            Img_Item = nil,
            Img_Mask = nil,
            Img_NumBG = nil,
            Txt_Num = nil
          },
          Group_First = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_FirstS = {
            self = nil,
            Img_ = nil,
            Txt_ = nil
          },
          Group_Allready = {self = nil, Img_ = nil}
        }
      }
    },
    Group_Fight = {
      self = nil,
      Btn_StartFight = {
        self = nil,
        Txt_Start = nil,
        Img_Bg = nil,
        Img_Icon = nil,
        Txt_Num = nil
      },
      Group_Energy = {
        self = nil,
        Img_Bg = nil,
        Img_Energy = nil,
        Txt_Cost = nil
      },
      Group_RecoLevel = {self = nil, Txt_RecoLevel = nil},
      Group_Lock = {
        self = nil,
        Img_Bg = nil,
        Txt_T = nil
      }
    },
    Group_Progress = {
      self = nil,
      Txt_T = nil,
      Txt_Des = nil,
      Txt_Num = nil
    },
    Group_Item = {
      self = nil,
      Img_BG = nil,
      Img_Icon = nil,
      Txt_Num = nil
    }
  },
  Group_Best = {
    self = nil,
    Img_Bg = nil,
    Img_Icon = nil,
    Btn_Check = {
      self = nil,
      Txt_T = nil,
      Img_Icon = nil
    },
    Btn_Reward = {
      self = nil,
      Txt_T = nil,
      Img_Icon = nil,
      Img_Red = nil
    },
    Txt_T = nil,
    Txt_Time = nil
  },
  Group_CommonTopLeft = {
    self = nil,
    Btn_Return = nil,
    Btn_Home = nil,
    Btn_Menu = {self = nil, Txt_ = nil},
    Btn_Help = {self = nil, Txt_ = nil}
  },
  Group_TimeReward = {
    self = nil,
    Img_B = nil,
    Btn_Close = {self = nil, Txt_ = nil},
    Img_Bg = {
      self = nil,
      Img_Icon = nil,
      Img_Icon2 = nil,
      Txt_T = nil,
      Txt_Des = nil
    },
    ScrollGrid_Level = {
      self = nil,
      grid = {
        self = nil,
        Group_Not = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Des = nil,
          Txt_T = nil,
          Group_Time = {
            self = nil,
            Txt_M = nil,
            Txt_Fen = nil,
            Txt_S = nil,
            Txt_Miao = nil
          }
        },
        Group_Can = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Des = nil,
          Txt_T = nil,
          Group_Time = {
            self = nil,
            Txt_M = nil,
            Txt_Fen = nil,
            Txt_S = nil,
            Txt_Miao = nil
          },
          Btn_Click = nil
        },
        ScrollGrid_Reward = {
          self = nil,
          grid = {
            self = nil,
            Group_Item = {
              self = nil,
              Btn_Item = nil,
              Img_Bottom = nil,
              Img_Item = nil,
              Img_Mask = nil,
              Group_Break = {
                self = nil,
                Img_Mask = {self = nil, Img_Face = nil},
                Img_F = nil
              },
              Txt_Num = nil,
              Img_Type01 = nil,
              Img_Type02 = nil,
              Group_EType = {
                self = nil,
                Img_IconBg = nil,
                Img_Icon = nil
              },
              Img_TimeLeft = {
                self = nil,
                Img_ = nil,
                Txt_ = nil
              },
              Group_Extra = {
                self = nil,
                Img_bg = {self = nil, Txt_txt = nil}
              },
              Group_Effect = nil
            }
          }
        },
        Group_Complete = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Des = nil,
          Txt_T = nil,
          Group_Time = {
            self = nil,
            Txt_M = nil,
            Txt_Fen = nil,
            Txt_S = nil,
            Txt_Miao = nil
          },
          Img_Mask = nil,
          Img_Icon2 = nil,
          Txt_ = nil,
          Txt_ = nil
        }
      }
    }
  },
  Group_BuffList = {
    self = nil,
    Img_B = nil,
    Btn_Close = {self = nil, Txt_ = nil},
    Txt_BossName = nil,
    Img_Banner = nil,
    ScrollView_Buff = {
      self = nil,
      Viewport = {
        self = nil,
        Content = {
          self = nil,
          Img_EnemyBuff000 = {
            self = nil,
            Group_Left = {
              self = nil,
              Img_Ordinal = nil,
              Txt_Ordinal = nil,
              Txt_Numeric = nil,
              Txt_Resistance = nil
            },
            Img_Triangle = nil,
            Txt_Des = nil
          },
          Img_EnemyBuff001 = {
            self = nil,
            Group_Left = {
              self = nil,
              Img_Ordinal = nil,
              Txt_Ordinal = nil,
              Txt_Numeric = nil,
              Txt_Resistance = nil
            },
            Img_Triangle = nil,
            Txt_Des = nil
          },
          Img_EnemyBuff002 = {
            self = nil,
            Group_Left = {
              self = nil,
              Img_Ordinal = nil,
              Txt_Ordinal = nil,
              Txt_Numeric = nil,
              Txt_Resistance = nil
            },
            Img_Triangle = nil,
            Txt_Des = nil
          },
          Img_EnemyBuff003 = {
            self = nil,
            Group_Left = {
              self = nil,
              Img_Ordinal = nil,
              Txt_Ordinal = nil,
              Txt_Numeric = nil,
              Txt_Resistance = nil
            },
            Img_Triangle = nil,
            Txt_Des = nil
          },
          Img_EnemyBuff004 = {
            self = nil,
            Group_Left = {
              self = nil,
              Img_Ordinal = nil,
              Txt_Ordinal = nil,
              Txt_Numeric = nil,
              Txt_Resistance = nil
            },
            Img_Triangle = nil,
            Txt_Des = nil
          }
        }
      }
    }
  },
  Group_CommomBottomLeft = {
    self = nil,
    Group_Items = {
      self = nil,
      Img_B = nil,
      Txt_Name = nil,
      Txt_Num = nil
    },
    Group_Progress = {
      self = nil,
      Img_B = nil,
      Txt_T = nil,
      Txt_Num = nil
    },
    Btn_Rank = nil
  },
  Btn_Abyss = {
    self = nil,
    Img_Icon1 = nil,
    Img_Icon2 = nil,
    Img_Red = nil,
    Txt_T = nil
  }
}
return BattleBoss
