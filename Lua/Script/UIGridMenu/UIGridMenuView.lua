local GridMenu = {
  self = nil,
  Img_ = nil,
  Img_Mask = nil,
  Img_Plane = {
    self = nil,
    Img_BG = {
      self = nil,
      Btn_Rank = {self = nil, Txt_ = nil},
      Btn_Get = {
        self = nil,
        Txt_ = nil,
        Img_ = nil,
        Img_RedPoint = nil
      },
      Group_Info = {
        self = nil,
        Txt_OutputNum = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil
        },
        Txt_InvestNum = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil
        },
        Txt_OutPutLimit = {
          self = nil,
          Img_UP = nil,
          Img_Down = nil
        },
        Txt_OutPut = {
          self = nil,
          Img_UP = nil,
          Img_Down = nil
        }
      },
      Group_God = {
        self = nil,
        Img_NoGod = nil,
        Txt_ = nil,
        Img_God = nil,
        Group_Time = {
          self = nil,
          Txt_ = nil,
          Txt_Time = nil
        },
        Img_Des = {
          self = nil,
          Img_Debuff = nil,
          Txt_ = nil,
          StaticGrid_Txt = {
            self = nil,
            grid = {self = nil, Txt_BuffDes = nil}
          },
          Group_Txt = {self = nil, Txt_BuffDes = nil}
        }
      }
    }
  },
  Img_Left = {
    self = nil,
    Img_City = nil,
    Group_Lv = {
      self = nil,
      Img_BG = {self = nil, Img_ProgressBar = nil},
      Img_Icon = {
        self = nil,
        Img_ = {self = nil, Txt_LV = nil}
      },
      Txt_CityName = nil,
      Txt_Exp = nil
    },
    Txt_Tips1 = nil,
    Txt_Tips2 = nil
  },
  Btn_Main = {
    self = nil,
    Txt_ = nil,
    Img_ = nil,
    Img_On = {
      self = nil,
      Txt_ = nil,
      Img_ = nil
    }
  },
  Btn_Invest = {
    self = nil,
    Txt_ = nil,
    Img_ = nil,
    Img_On = {
      self = nil,
      Txt_ = nil,
      Img_ = nil
    }
  },
  Group_Monopolis = {
    self = nil,
    Img_ = nil,
    Img_Mask = nil,
    Img_BG = nil,
    Group_Title = {
      self = nil,
      Img_BG = nil,
      Txt_En = nil,
      Txt_Cn = nil,
      Img_Tips = {
        self = nil,
        Img_Icon = nil,
        Txt_Tip = nil
      }
    },
    Btn_CitySwitch = {
      self = nil,
      Txt_0 = nil,
      Txt_City = nil,
      Img_0 = nil,
      Img_1 = nil
    },
    Group_RewardList = {
      self = nil,
      BG = nil,
      Btn_Day = {
        self = nil,
        Img_Default = {self = nil, Txt_0 = nil},
        Img_Active = {self = nil, Txt_0 = nil}
      },
      Btn_Issue = {
        self = nil,
        Img_Default = {self = nil, Txt_0 = nil},
        Img_Active = {self = nil, Txt_0 = nil}
      },
      ScrollGrid_RewardList = {
        self = nil,
        grid = {
          self = nil,
          Img_BG = nil,
          Txt_Rank = nil,
          StaticGrid_Reward = {
            self = nil,
            grid = {
              self = nil,
              Btn_Item = nil,
              Img_Bottom = nil,
              Img_Item = nil,
              Img_Mask = nil,
              Txt_Num = nil,
              Group_Effect = nil
            }
          }
        }
      }
    },
    Group_RankList = {
      self = nil,
      Img_Title = {
        self = nil,
        Txt_01 = nil,
        Txt_02 = nil,
        Txt_03 = nil
      },
      Group_Empty = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      ScrollGrid_RankList = {
        self = nil,
        grid = {
          self = nil,
          Img_No1 = nil,
          Img_No2 = nil,
          Img_No3 = nil,
          Img_No4 = {
            self = nil,
            Txt_0 = nil,
            Txt_Num = nil
          },
          Txt_Name = nil,
          Group_LV = {
            self = nil,
            Txt_0 = nil,
            Txt_LV = nil
          },
          Group_Coin = {
            self = nil,
            Img_Icon = nil,
            Txt_Num = nil
          },
          Group_Head = {
            self = nil,
            Img_BG = nil,
            Img_ProfilePhoto = {self = nil, Img_Head = nil}
          }
        }
      },
      Group_Oneself = {
        self = nil,
        Img_No1 = nil,
        Img_No2 = nil,
        Img_No3 = nil,
        Img_No4 = {
          self = nil,
          Txt_0 = nil,
          Txt_Num = nil
        },
        Txt_Name = nil,
        Group_LV = {
          self = nil,
          Txt_0 = nil,
          Txt_LV = nil
        },
        Group_Coin = {
          self = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Group_Head = {
          self = nil,
          Img_BG = nil,
          Img_ProfilePhoto = {self = nil, Img_Head = nil}
        }
      }
    },
    Group_CityList = {
      self = nil,
      Img_BG = nil,
      ScrollGrid_CityList = {
        self = nil,
        grid = {
          self = nil,
          Img_0 = nil,
          Btn_Change = nil,
          Txt_City = nil,
          Group_Present = {
            self = nil,
            Img_Icon = {self = nil, Txt_0 = nil},
            Txt_City = {self = nil, Text = nil}
          }
        }
      }
    }
  },
  Group_Invest = {
    self = nil,
    Group_Right = {
      self = nil,
      Img_BG = nil,
      Group_Top = {
        self = nil,
        Group_Title = {
          self = nil,
          Img_Icon = nil,
          Txt_0 = nil
        },
        Txt_InvestNum = nil,
        Img_InvestTimes = {self = nil, Txt_InvestTimes = nil}
      },
      Img_Coin = {
        self = nil,
        Img_ = nil,
        Txt_Num = nil
      },
      ScrollGrid_InvestList = {
        self = nil,
        grid = {
          self = nil,
          Img_BG = nil,
          Group_Cost = {
            self = nil,
            Img_Icon = nil,
            Txt_Title = nil,
            Img_Coin = nil,
            Txt_CostNum = nil
          },
          Btn_Invest = {
            self = nil,
            Img_Icon = nil,
            Txt_0 = nil
          },
          Img_Unable = {
            self = nil,
            Img_Icon = nil,
            Txt_0 = nil
          }
        }
      }
    },
    Img_Middle = nil
  },
  Group_CommonTopLeft = {
    self = nil,
    Btn_Return = nil,
    Btn_Home = nil,
    Btn_Menu = nil,
    Btn_Help = {
      self = nil,
      Img_Tips = {
        self = nil,
        Img_icon = nil,
        Txt_ = nil
      }
    }
  },
  Group_LV = {
    self = nil,
    Img_ = nil,
    Img_Mask = nil,
    UI_ciryPrestigeUp = {
      self = nil,
      Glow2 = nil,
      lizi = nil,
      glow3 = nil,
      glow = nil,
      yuan = nil,
      line = nil,
      star = nil,
      glow4_Flash = nil,
      star = nil
    },
    Img_LvUP = {
      self = nil,
      Txt_OldLV = nil,
      Img_ = nil,
      Txt_NewLV = nil
    }
  },
  Img_prevent = nil
}
return GridMenu
