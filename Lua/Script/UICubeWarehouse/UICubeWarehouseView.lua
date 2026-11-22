local CubeWarehouse = {
  self = nil,
  Img_BG = nil,
  Group_Top = {
    self = nil,
    Txt_Name = nil,
    Group_Buff = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_ = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Group_On = {
        self = nil,
        Img_ = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Btn_ = nil
    },
    Group_Weapon = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_ = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Group_On = {
        self = nil,
        Img_ = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Btn_ = nil
    },
    Group_Team = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_ = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Group_On = {
        self = nil,
        Img_ = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Btn_ = nil
    }
  },
  Group_Buff = {
    self = nil,
    ScrollGrid_Buff = {
      self = nil,
      grid = {
        self = nil,
        Img_Bg = nil,
        Img_TypeIcon = nil,
        Img_Icon = nil,
        Img_Level = nil,
        Img_Level2 = nil,
        Img_Type = nil,
        Txt_Name = nil,
        ScrollView_DefaultDes = {
          self = nil,
          Viewport = {
            self = nil,
            Content = {
              self = nil,
              Txt_Tyep = nil,
              Txt_Already = nil,
              Txt_DefaultDes = nil,
              Img_0 = {self = nil, Txt_ = nil},
              Txt_UpdateDes = nil
            }
          }
        },
        Img_Selected = nil,
        Img_Recommend = {self = nil, Txt_ = nil},
        Img_NotGet = {self = nil, Txt_ = nil},
        Btn_ = nil
      }
    },
    StaticGrid_List = {
      self = nil,
      grid = {
        self = nil,
        Group_Off = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Group_On = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Btn_ = nil
      }
    },
    Group_Empty = nil,
    Group_Item = {
      self = nil,
      Group_Off = {
        self = nil,
        Img_Bg = nil,
        Img_Icon = nil,
        Txt_Num = nil
      },
      Group_On = {
        self = nil,
        Img_ = nil,
        Img_Icon = nil,
        Txt_Num = nil
      },
      Btn_ = nil
    }
  },
  Group_Weapon = {
    self = nil,
    Group_Quality = {
      self = nil,
      Group_All = {
        self = nil,
        Group_Off = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Group_On = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Btn_ = nil
      },
      Group_Orange = {
        self = nil,
        Group_Off = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Group_On = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Btn_ = nil
      },
      Group_Golden = {
        self = nil,
        Group_Off = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Group_On = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Btn_ = nil
      },
      Group_Purple = {
        self = nil,
        Group_Off = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Group_On = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Btn_ = nil
      },
      Group_Blue = {
        self = nil,
        Group_Off = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Group_On = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Btn_ = nil
      },
      Group_Negative = {
        self = nil,
        Group_Off = {
          self = nil,
          Img_Bg = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Group_On = {
          self = nil,
          Img_ = nil,
          Img_Icon = nil,
          Txt_Num = nil
        },
        Btn_ = nil
      }
    },
    ScrollGrid_Weapon = {
      self = nil,
      grid = {
        self = nil,
        Img_Bg = nil,
        Img_Icon = nil,
        Txt_Name = nil,
        Txt_Type = nil,
        ScrollView_Des = {
          self = nil,
          Viewport = {
            self = nil,
            Content = {self = nil, Txt_Des = nil}
          }
        },
        Group_Remaining = {
          self = nil,
          Txt_Remaining = nil,
          Txt_Num = nil
        },
        Img_Selected = nil,
        Img_NotGet = nil,
        Group_Destroy = {self = nil, Img_Mask = nil}
      }
    },
    Group_Centre = {
      self = nil,
      Img_Icon = nil,
      Img_Quality = nil,
      Txt_Name = nil,
      ScrollView_DefaultDes = {
        self = nil,
        Viewport = {
          self = nil,
          Content = {self = nil, Txt_DefaultDes = nil}
        }
      },
      Img_ = nil
    },
    Group_Bottom = {
      self = nil,
      ScrollGrid_Weapon = {
        self = nil,
        grid = {
          self = nil,
          Img_Quality = nil,
          Img_Icon = nil,
          Txt_Name = nil,
          Img_Select = nil,
          Btn_ = {self = nil, Txt_ = nil}
        }
      }
    },
    Group_Empty = nil
  },
  Group_Team = {
    self = nil,
    Group_Item = {
      self = nil,
      Group_Not = {
        self = nil,
        Img_ = nil,
        Txt_ = nil,
        Txt_ = nil,
        Txt_ = nil
      },
      Group_Complete = {
        self = nil,
        Img_ = nil,
        Txt_Name = nil,
        Img_Icon = nil,
        Group_ = {
          self = nil,
          Img_ = nil,
          Txt_ = nil
        }
      },
      Group_Num = {
        self = nil,
        Img_ = nil,
        Txt_Present = nil,
        Txt_ = nil,
        Txt_Total = nil
      },
      ScrollView_DefaultDes = {
        self = nil,
        Viewport = {
          self = nil,
          Content = {self = nil, Txt_DefaultDes = nil}
        }
      },
      Group_Schedule = {
        self = nil,
        Group_S1 = {
          self = nil,
          Img_Di = nil,
          Img_Schedule = nil
        },
        Group_S2 = {
          self = nil,
          Img_Di = nil,
          Img_Schedule = nil
        },
        Group_S3 = {
          self = nil,
          Img_Di = nil,
          Img_Schedule = nil
        },
        Group_S4 = {
          self = nil,
          Img_Di = nil,
          Img_Schedule = nil
        },
        Group_S5 = {
          self = nil,
          Img_Di = nil,
          Img_Schedule = nil
        }
      },
      Txt_Type = nil,
      Img_Type = nil
    },
    ScrollView_List = {
      self = nil,
      Viewport = {
        self = nil,
        Content = {
          self = nil,
          Group_Bottom = {
            self = nil,
            Img_Di = nil,
            Img_Schedule = nil,
            Img_1 = nil,
            Img_2 = nil,
            Img_3 = nil,
            Img_4 = nil,
            Img_5 = nil
          },
          StaticGrid_List = {
            self = nil,
            grid = {
              self = nil,
              Group_Not = {
                self = nil,
                Img_ = nil,
                Txt_ = nil,
                Txt_ = nil,
                Txt_ = nil
              },
              Group_Complete = {
                self = nil,
                Img_ = nil,
                Txt_Name = nil,
                Img_Icon = nil,
                Group_ = {
                  self = nil,
                  Img_ = nil,
                  Txt_ = nil
                }
              },
              Group_Num = {
                self = nil,
                Img_ = nil,
                Txt_Present = nil,
                Txt_ = nil,
                Txt_Total = nil
              },
              ScrollView_DefaultDes = {
                self = nil,
                Viewport = {
                  self = nil,
                  Content = {self = nil, Txt_DefaultDes = nil}
                }
              },
              Group_Schedule = {
                self = nil,
                Group_S1 = {
                  self = nil,
                  Img_Di = nil,
                  Img_Schedule = nil
                },
                Group_S2 = {
                  self = nil,
                  Img_Di = nil,
                  Img_Schedule = nil
                },
                Group_S3 = {
                  self = nil,
                  Img_Di = nil,
                  Img_Schedule = nil
                },
                Group_S4 = {
                  self = nil,
                  Img_Di = nil,
                  Img_Schedule = nil
                },
                Group_S5 = {
                  self = nil,
                  Img_Di = nil,
                  Img_Schedule = nil
                }
              },
              Txt_Type = nil,
              Img_Type = nil
            }
          }
        }
      }
    }
  },
  Group_Coin = {
    self = nil,
    Img_ = nil,
    Btn_GoldCoin = nil,
    Img_Icon = nil,
    Txt_Num = nil
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
return CubeWarehouse
