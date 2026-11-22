local KabaneriMain = {
  self = nil,
  Img_MainBg = nil,
  Group_StaticMonsHp = {
    self = nil,
    Img_HpBG = nil,
    Img_Bar = nil,
    Txt_Name = nil,
    Txt_Value = nil
  },
  Group_ForkRoadWarn = {
    self = nil,
    Img_BG = nil,
    Group_Buff = {
      self = nil,
      Group_Buff1 = {
        self = nil,
        Img_BuffImg = nil,
        Img_BuffDesc = {
          self = nil,
          Txt_BuffName = nil,
          Txt_BuffDesc = nil
        },
        Img_Select = {
          self = nil,
          Img_BuffIcon = nil,
          Txt_BuffName = nil
        },
        Btn_Buff1 = nil,
        Img_ = nil
      },
      Group_Buff2 = {
        self = nil,
        Img_BuffImg = nil,
        Img_BuffDesc = {
          self = nil,
          Txt_BuffName = nil,
          Txt_BuffDesc = nil
        },
        Img_Select = {
          self = nil,
          Img_BuffIcon = nil,
          Txt_BuffName = nil
        },
        Btn_Buff2 = nil,
        Img_ = nil
      },
      Group_Buff3 = {
        self = nil,
        Img_BuffImg = nil,
        Img_BuffDesc = {
          self = nil,
          Txt_BuffName = nil,
          Txt_BuffDesc = nil
        },
        Img_Select = {
          self = nil,
          Img_BuffIcon = nil,
          Txt_BuffName = nil
        },
        Btn_Buff3 = nil,
        Img_ = nil
      }
    },
    Group_Progress = {
      self = nil,
      Img_ProgressBg = nil,
      Img_ProgressLine = nil
    }
  },
  Group_MonsterWarn = {
    self = nil,
    Img_circleBg = nil,
    Img_BG = nil,
    Img_sides = nil,
    Img_triangle = nil,
    Img_EnTxt = nil,
    Txt_WarnTxt = nil,
    Txt_condition = nil
  },
  BossStatus = {
    self = nil,
    Hp = {
      self = nil,
      Bg = nil,
      Tween = nil,
      Img_Bar = {
        self = nil,
        Group_SubBar = {
          self = nil,
          Img_SubBar = nil,
          Img_SubBar1 = nil,
          Img_SubBar2 = nil
        },
        Origin = {
          self = nil,
          tail = {
            self = nil,
            View = {self = nil, UI_bossHp_01 = nil}
          }
        },
        Shield = nil
      }
    },
    Energy = {
      self = nil,
      Bg = nil,
      Bar = nil
    },
    Name = {
      self = nil,
      Text = nil,
      Icon = nil
    }
  },
  Group_Common = {
    self = nil,
    Btn_Return = nil,
    Img_Fixcircle = {
      self = nil,
      Img_Maintenance = nil,
      Img_empty = nil,
      Img_Shield = nil,
      Img_numberbg = nil,
      Txt_Durability = nil,
      Txt_DurabilityName = nil,
      Txt_ShieldNum = nil,
      Img_full = nil
    },
    Group_MB = {
      self = nil,
      Img_Speed = {
        self = nil,
        Img_Blur = nil,
        Img_S = nil,
        Img_Pointer = nil,
        Img_BP = nil,
        Txt_Speed = nil,
        Txt_SpeedUnit = nil,
        Txt_S = nil
      },
      Group_PollutionIndex = {
        self = nil,
        Img_Mask = {
          self = nil,
          Group_Color = {self = nil, Img_Color = nil}
        },
        Img_Now = nil
      },
      Btn_Electric = nil,
      Group_Lighting = nil,
      SpineNode_Warning = {self = nil, Group_Sound = nil},
      SpineNode_Rush = nil,
      Group_Buff = {
        self = nil,
        Group_Item = {
          self = nil,
          Group_List = {
            self = nil,
            Img_IconBg = {
              self = nil,
              Btn_BuffIcon = {self = nil, Img_Icon = nil}
            },
            Img_IconMask = nil,
            Txt_Time = nil
          }
        },
        StaticGrid_List = {
          self = nil,
          grid = {
            self = nil,
            Group_List = {
              self = nil,
              Img_IconBg = {
                self = nil,
                Btn_BuffIcon = {self = nil, Img_Icon = nil}
              },
              Img_IconMask = nil,
              Txt_Time = nil
            }
          }
        },
        Btn_Close = {
          self = nil,
          Img_BuffDesc = {
            self = nil,
            Txt_BuffName = nil,
            Txt_BuffTime = nil,
            Txt_BuffDesc = nil
          }
        }
      }
    },
    Group_battery = {
      self = nil,
      Group_ammoNum = {
        self = nil,
        Img_ammoNum = nil,
        Txt_ammoNum = nil,
        Txt_Num = nil
      },
      Group_Noammo = {
        self = nil,
        Img_NoAmmoMask = nil,
        Img_NoAmmoCircle = nil,
        Img_ammoNum = nil,
        Img_NoAmmoBg = nil,
        Txt_NoAmmoTxt = nil,
        Txt_NoAmmoTxt2 = nil
      }
    },
    Group_Running = {self = nil, Group_RushEffect = nil},
    Btn_Accelerate = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_Icon = nil,
        Img_Bg = nil,
        Txt_Num = nil
      },
      Group_On = {
        self = nil,
        Img_Icon = nil,
        Img_Bg = nil,
        Txt_Num = nil,
        Img_On = nil
      },
      Group_Ing = {
        self = nil,
        Img_Bg = nil,
        Img_Bar = nil,
        Txt_Des = nil,
        Txt_Time2 = nil,
        Txt_Time = nil,
        Group_RushTime = nil,
        Group_RushBuyBtn = nil
      }
    },
    Group_Gear = {
      self = nil,
      Img_Btm = nil,
      Img_Gear = nil,
      Btn_M = {
        self = nil,
        Group_Off = {self = nil, Img_D = nil},
        Group_On = {self = nil, Img_D = nil},
        Group_None = {self = nil, Img_D = nil}
      },
      Btn_L = {
        self = nil,
        Group_Off = {self = nil, Img_B = nil},
        Group_On = {self = nil, Img_B = nil},
        Group_None = {self = nil, Img_B = nil}
      },
      Btn_R = {
        self = nil,
        Group_Off = {self = nil, Img_R = nil},
        Group_On = {self = nil, Img_R = nil},
        Group_None = {self = nil, Img_R = nil}
      }
    },
    Group_MainInfo = {
      self = nil,
      Img_InfoBg = nil,
      Group_Point = {
        self = nil,
        Group_PointIcon = {self = nil, Img_PointIcon = nil},
        Txt_Score = nil
      },
      Group_Time = {
        self = nil,
        Group_TimeIcon = {self = nil, Img_TimeIcon = nil},
        Txt_TimeNum = nil
      }
    },
    Slider_Shoot = {
      self = nil,
      Img_Bg = nil,
      Img_On = nil,
      Group_Fill = {self = nil, Img_Fill = nil},
      Group_Handle = {self = nil, Img_Handle = nil},
      Txt_ = nil
    },
    Group_TrainOverview = {
      self = nil,
      Btn_All = {
        self = nil,
        Img_Icon = nil,
        Txt_All = nil
      },
      Group_Overview = {
        self = nil,
        Img_Glass = {
          self = nil,
          Img_Base = {
            self = nil,
            Group_Title = {
              self = nil,
              Img_Icon = nil,
              Txt_Text = nil
            },
            Group_Durable = {
              self = nil,
              Img_Icon = nil,
              Txt_Text = nil,
              Txt_Num = nil,
              Img_Line = nil
            },
            Group_Impact = {
              self = nil,
              Img_Icon = nil,
              Txt_Text = nil,
              Txt_Num = nil,
              Img_Line = nil
            },
            Group_Firepower = {
              self = nil,
              Img_Icon = nil,
              Txt_Text = nil,
              Txt_Num = nil,
              Img_Line = nil
            },
            Group_Armor = {
              self = nil,
              Img_Icon = nil,
              Txt_Text = nil,
              Txt_Num = nil,
              Img_Line = nil
            },
            Group_Xiexiang = {
              self = nil,
              Img_Icon = nil,
              Txt_Text = nil,
              Txt_Num = nil,
              Img_Line = nil
            },
            Group_Weishe = {
              self = nil,
              Img_Icon = nil,
              Txt_Text = nil,
              Txt_Num = nil,
              Img_Line = nil
            },
            Group_Good = {
              self = nil,
              Img_Icon = nil,
              Txt_Text = nil,
              Txt_Num = nil,
              Img_Line = nil
            },
            Group_All = {
              self = nil,
              Img_Icon = nil,
              Txt_Text = nil,
              Txt_Num = nil
            },
            Group_Speed = {
              self = nil,
              Img_SpeedChange = {
                self = nil,
                Img_SpeedEffect = {self = nil, Txt_SpeedEffect = nil},
                Group_Skill = {
                  self = nil,
                  Txt_Text = nil,
                  Txt_Num = nil,
                  Img_Line = nil
                },
                Group_Drink = {
                  self = nil,
                  Txt_Text = nil,
                  Txt_Num = nil,
                  Img_Line = nil
                },
                Group_Weight = {
                  self = nil,
                  Txt_Text = nil,
                  Txt_Num = nil,
                  Img_Line = nil
                },
                Group_Goods = {
                  self = nil,
                  Txt_Text = nil,
                  Txt_Num = nil,
                  Img_Line = nil
                },
                Group_Maintenance = {
                  self = nil,
                  Txt_Text = nil,
                  Txt_Num = nil,
                  Img_Line = nil
                },
                Group_Carriage = {
                  self = nil,
                  Txt_Text = nil,
                  Txt_Num = nil,
                  Img_Line = nil
                },
                Group_Weapon = {
                  self = nil,
                  Txt_Text = nil,
                  Txt_Num = nil
                }
              }
            }
          }
        }
      },
      Btn_CloseOverview = nil
    },
    Group_Pause = {
      self = nil,
      Img_VaBG = nil,
      Btn_Close = nil,
      Img_BgWheel = {
        self = nil,
        Img_CenterCircle = nil,
        Img_OutCircle = nil,
        Img_Gear = nil,
        Img_Circle = nil
      },
      Group_Tips = {
        self = nil,
        Img_Tips = nil,
        Txt_Tips = nil
      },
      Img_BG = nil,
      Btn_Exit = {self = nil, Txt_Txt = nil},
      Btn_Continue = {self = nil, Txt_Txt = nil},
      Txt_Title = nil
    }
  },
  Txt_Debug = nil,
  Txt_mileage = nil,
  Group_Over = {
    self = nil,
    Img_BG = nil,
    Btn_Close = {self = nil, Txt_ = nil},
    Group_Victory = {
      self = nil,
      Img_BgWheel = {
        self = nil,
        Img_CenterCircle = nil,
        Img_OutCircle = nil,
        Img_Gear = nil,
        Img_Circle = nil
      },
      Img_Result = nil,
      Img_Txt = nil,
      Img_Point = {
        self = nil,
        Img_PointIcon = nil,
        Txt_Point = nil,
        Txt_Num = nil
      },
      Img_Time = {
        self = nil,
        Img_TimeIcon = nil,
        Txt_Time = nil,
        Txt_Num = nil
      }
    },
    Group_Defeat = {
      self = nil,
      Img_BgWheel = {
        self = nil,
        Img_CenterCircle = nil,
        Img_OutCircle = nil,
        Img_Gear = nil,
        Img_Circle = nil
      },
      Img_Result = nil,
      Img_Txt = nil,
      Img_Point = {
        self = nil,
        Img_PointIcon = nil,
        Txt_Point = nil,
        Txt_Num = nil
      },
      Img_Time = {
        self = nil,
        Img_TimeIcon = nil,
        Txt_Time = nil,
        Txt_Num = nil
      }
    },
    Group_Tips = {
      self = nil,
      Img_Tips = nil,
      Txt_Tips = nil
    },
    Img_RewordBG = {
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
        Img_Time = {self = nil, Txt_ = nil},
        Img_Effect = nil,
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
        }
      },
      ScrollGrid_ = {
        self = nil,
        grid = {
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
          Img_Time = {self = nil, Txt_ = nil},
          Img_Effect = nil,
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
          }
        }
      }
    },
    Img_NoReward = {
      self = nil,
      Img_NoRewardMask = nil,
      Txt_NoReward = nil
    },
    Group_Btns = {
      self = nil,
      Btn_ReStartGame = {
        self = nil,
        Img_ = nil,
        Txt_Txt = nil
      },
      Txt_Auto = nil,
      Btn_CloseGame = {
        self = nil,
        Img_ = nil,
        Txt_Txt = nil
      }
    }
  }
}
return KabaneriMain
