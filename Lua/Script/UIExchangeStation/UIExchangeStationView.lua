local ExchangeStation = {
  self = nil,
  Img_BG = nil,
  Img_BGMask = nil,
  Group_NPC = {
    self = nil,
    Img_Role = nil,
    SpineAnimation_Character = nil,
    SpineAnimation_Alpha = nil,
    Img_Dialog = {self = nil, Txt_Talk = nil},
    Img_Name = {self = nil, Txt_Name = nil}
  },
  Img_NPCMask = nil,
  Group_Main = {
    self = nil,
    Group_NpcInfo = {
      self = nil,
      Img_Icon = nil,
      Txt_Name = nil,
      Group_Dingwei = {
        self = nil,
        Img_ = nil,
        Txt_Station = nil
      },
      Img_1 = nil
    },
    Group_Btn = {
      self = nil,
      Btn_List = {
        self = nil,
        Txt_Dec = nil,
        Img_Icon = nil,
        Group_Time = {
          self = nil,
          Img_1 = nil,
          Txt_Time = nil
        },
        Img_Limit = {
          self = nil,
          Txt_Dec = nil,
          Img_Icon = nil,
          Img_1 = nil,
          Img_2 = nil,
          Txt_Time = nil
        },
        Img_RedPoint = nil
      }
    },
    StaticGrid_List = {
      self = nil,
      grid = {
        self = nil,
        Btn_List = {
          self = nil,
          Txt_Dec = nil,
          Img_Icon = nil,
          Group_Time = {
            self = nil,
            Img_1 = nil,
            Txt_Time = nil
          },
          Img_Limit = {
            self = nil,
            Txt_Dec = nil,
            Img_Icon = nil,
            Img_1 = nil,
            Img_2 = nil,
            Txt_Time = nil
          },
          Img_RedPoint = nil
        }
      }
    }
  },
  Group_Construction = {
    self = nil,
    Img_ = nil,
    Img_ = nil,
    Txt_Num = nil,
    Txt_PersonalNum = nil,
    Group_All = {
      self = nil,
      Img_ = nil,
      Img_Progress = nil
    },
    Group_Personal = {
      self = nil,
      Img_ = nil,
      Img_Progress = nil
    },
    Txt_ = nil,
    Txt_ = nil,
    Img_RedPoint = nil,
    Btn_ = nil
  },
  Group_Time = {
    self = nil,
    Img_Icon = nil,
    Txt_ = nil,
    Txt_Time = nil
  },
  Group_Zhu = {
    self = nil,
    Txt_Name = nil,
    Img_2 = nil,
    Group_Dingwei = {
      self = nil,
      Img_ = nil,
      Txt_Station = nil
    },
    Group_Construct = {
      self = nil,
      Btn_Construct = {self = nil, Img_Click = nil},
      Txt_Dec = nil,
      Txt_Num = nil,
      Img_PBBG = nil,
      Img_PB = nil,
      Img_RedPoint = nil
    },
    Group_Reputation = {
      self = nil,
      Btn_Reputation = {self = nil, Img_Click = nil},
      Txt_Grade = nil,
      Txt_Num = nil,
      Img_PBBG = nil,
      Img_PB = nil,
      Img_RedPoint = nil
    },
    Img_Icon = nil
  },
  Group_Tab = {
    self = nil,
    Img_Btm = nil,
    Img_Selected = nil,
    Btn_Buy = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Group_On = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      }
    },
    Btn_Sell = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      },
      Group_On = {
        self = nil,
        Img_ = nil,
        Txt_ = nil
      }
    }
  },
  Group_Exchange = {
    self = nil,
    Group_Ding = {
      self = nil,
      Group_Top = {
        self = nil,
        Group_Time = {
          self = nil,
          Img_BG = nil,
          Txt_Time = nil,
          Btn_Tips = {self = nil, Img_Click = nil}
        },
        StaticGrid_Coin = {
          self = nil,
          grid = {
            self = nil,
            Img_BG = nil,
            Btn_GoldCoin = nil,
            Img_Icon = nil,
            Txt_Num = nil,
            Btn_Add = nil
          }
        }
      }
    },
    Group_Middle = {
      self = nil,
      Img_BG = nil,
      Img_Di = nil,
      Group_Title = {
        self = nil,
        Img_Title = nil,
        Txt_Title = nil
      },
      ScrollGrid_List = {
        self = nil,
        grid = {
          self = nil,
          Img_Di = nil,
          Img_Icon = {self = nil, Btn_ = nil},
          Group_Name = {
            self = nil,
            Img_ = nil,
            Txt_Name = nil,
            Txt_NameL = {self = nil, Text_Name = nil}
          },
          Group_Num = {
            self = nil,
            Img_Bg = nil,
            Img_ = nil,
            Txt_Num = nil
          },
          Group_Item = {
            self = nil,
            Img_ = nil,
            Img_ = nil,
            Img_ = nil,
            Group_Consume1 = {
              self = nil,
              Img_NeedBottom = nil,
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
              },
              Group_Cost = {
                self = nil,
                Txt_Have = nil,
                Txt_And = nil,
                Txt_Need = nil
              },
              Group_Break = {
                self = nil,
                Img_Mask = {self = nil, Img_Face = nil},
                Img_F = nil
              }
            },
            Group_Consume2 = {
              self = nil,
              Img_NeedBottom = nil,
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
              },
              Group_Cost = {
                self = nil,
                Txt_Have = nil,
                Txt_And = nil,
                Txt_Need = nil
              },
              Group_Break = {
                self = nil,
                Img_Mask = {self = nil, Img_Face = nil},
                Img_F = nil
              }
            },
            Group_Consume3 = {
              self = nil,
              Img_NeedBottom = nil,
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
              },
              Group_Cost = {
                self = nil,
                Txt_Have = nil,
                Txt_And = nil,
                Txt_Need = nil
              },
              Group_Break = {
                self = nil,
                Img_Mask = {self = nil, Img_Face = nil},
                Img_F = nil
              }
            }
          },
          ScrollGrid_List = {
            self = nil,
            grid = {
              self = nil,
              Img_Empty = nil,
              Group_Cost = {
                self = nil,
                Txt_Have = nil,
                Txt_And = nil,
                Txt_Need = nil
              },
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
          Group_Time = {
            self = nil,
            Img_ = nil,
            Txt_Time = nil
          },
          Group_Btn = {
            self = nil,
            Group_Can = {
              self = nil,
              Img_ = nil,
              Btn_ = nil
            },
            Group_Not = {
              self = nil,
              Img_ = nil,
              Btn_ = nil
            }
          },
          Group_Extra = {
            self = nil,
            Txt_Num = nil,
            Img_Icon = {self = nil, Btn_ = nil}
          },
          Group_Quality = {
            self = nil,
            Img_ = nil,
            Img_Quality = nil
          },
          Group_Allready = {
            self = nil,
            Img_ = nil,
            Group_ = {
              self = nil,
              Img_Bg = nil,
              Img_ = nil,
              Txt_ = nil
            }
          },
          Group_Grade = {
            self = nil,
            Img_ = nil,
            Img_ = nil,
            Txt_Grade = nil,
            Txt_1 = nil
          }
        }
      }
    }
  },
  Group_OrderList = {
    self = nil,
    Group_Ding = {
      self = nil,
      Group_GoldCoin = {
        self = nil,
        Img_BG = nil,
        Btn_GoldCoin = nil,
        Img_Icon = nil,
        Txt_Num = nil,
        Btn_Add = nil
      },
      Group_Tips = {
        self = nil,
        Img_BG = nil,
        Txt_Tips = nil,
        Btn_Tips = {self = nil, Img_Click = nil}
      }
    },
    Group_Middle = {
      self = nil,
      Group_Title = {
        self = nil,
        Img_Title = nil,
        Txt_Title = {
          self = nil,
          Img_ = {self = nil, Txt_ = nil}
        },
        Txt_Dec = nil,
        Img_ = nil
      },
      ScrollGrid_List = {
        self = nil,
        grid = {
          self = nil,
          Img_BG = nil,
          Group_NotEnough = {
            self = nil,
            Img_ = nil,
            Group_ = {
              self = nil,
              Img_ = nil,
              Txt_ = nil
            }
          },
          Group_Enough = {
            self = nil,
            Img_ = nil,
            Group_ = {
              self = nil,
              Img_ = nil,
              Txt_ = nil
            }
          },
          Group_Information = {
            self = nil,
            Txt_Name = nil,
            Txt_DeliveryNum = nil,
            Txt_ = nil,
            Img_Icon = nil,
            Btn_ = nil,
            Group_residueNum = {
              self = nil,
              Txt_ = nil,
              Txt_ = nil,
              Group_Num = {
                self = nil,
                Img_ = nil,
                Txt_Num = nil
              },
              Group_Infinite = {
                self = nil,
                Img_ = nil,
                Img_ = nil
              },
              Group_Empty = {
                self = nil,
                Img_ = nil,
                Txt_Num = nil
              }
            },
            Group_Reward = {
              self = nil,
              Group_ = {
                self = nil,
                Img_ = nil,
                Txt_ = nil
              },
              Group_ItemReward = {
                self = nil,
                Btn_Item = nil,
                Img_Bottom = nil,
                Img_Item = nil,
                Img_Mask = nil,
                Txt_Num = nil,
                Group_Effect = nil
              },
              StaticGrid_RewardList = {
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
          },
          Group_Complete = {
            self = nil,
            Img_ = nil,
            Group_ = {
              self = nil,
              Img_ = nil,
              Txt_ = nil
            }
          },
          Btn_ = nil
        }
      }
    }
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
  }
}
return ExchangeStation
