local ParoleRoom = {
  self = nil,
  Img_BG = nil,
  Img_Mask = nil,
  Img_Blur = nil,
  Img_bg = nil,
  Img_Titlebg = nil,
  Group_GoldCoin = {
    self = nil,
    Img_BG = nil,
    Btn_GoldCoin = nil,
    Img_Icon = nil,
    Txt_Num = nil,
    Btn_Add = nil
  },
  Group_ParoleRoomList = {
    self = nil,
    Group_Title = {
      self = nil,
      Img_Icon = nil,
      Txt_RoomName = nil,
      Txt_Level = nil,
      Txt_LevelName = nil,
      Group_LowestScore = {
        self = nil,
        Img_bg = nil,
        Txt_LowestScore = nil,
        Btn_ = nil
      }
    },
    Img_Background = nil,
    Group_NoPrison = {
      self = nil,
      Img_ = nil,
      Txt_cn = nil,
      Txt_en = {self = nil, Txt_ = nil}
    },
    Group_Prisoner = {
      self = nil,
      Img_bg = nil,
      Group_Prisoner = {
        self = nil,
        Group_Title = {
          self = nil,
          Img_ = nil,
          Txt_ = nil,
          Txt_Num = nil
        },
        Group_PrisonerList = {
          self = nil,
          Group_Prisoner = {
            self = nil,
            Group_TitleCanParole = {
              self = nil,
              Img_ = nil,
              Txt_CanRelease = nil
            },
            Group_TitleCantParole = {
              self = nil,
              Img_ = nil,
              Txt_CanRelease = nil
            },
            Group_CantRelease = {
              self = nil,
              Img_ = nil,
              Group_Prisoner = {
                self = nil,
                Img_Prisoner = nil,
                Group_Num = {
                  self = nil,
                  Img_ = nil,
                  Txt_ = nil
                },
                Txt_Name = nil,
                Txt_Score = nil,
                Group_Money = {
                  self = nil,
                  Txt_ = nil,
                  Img_Icon = nil,
                  Img_ = nil
                },
                Txt_Time = nil,
                Img_ = nil
              }
            },
            Group_CanRelease = {
              self = nil,
              Img_ = nil,
              Group_Prisoner = {
                self = nil,
                Img_Prisoner = nil,
                Group_Num = {
                  self = nil,
                  Img_ = nil,
                  Txt_ = nil
                },
                Txt_Name = nil,
                Txt_Score = nil,
                Group_Money = {
                  self = nil,
                  Txt_ = nil,
                  Group_Money = {
                    self = nil,
                    Img_Icon = nil,
                    Txt_Num = nil
                  },
                  Txt_Commission = nil
                },
                Txt_Time = nil
              },
              Btn_ = {
                self = nil,
                Img_ = nil,
                Txt_ = nil
              }
            },
            Group_NoInfo = {self = nil, Txt_ = nil}
          },
          ScrollView_ = {
            self = nil,
            Viewport = {
              self = nil,
              Content = {
                self = nil,
                ScrollGrid_ = {
                  self = nil,
                  grid = {
                    self = nil,
                    Group_TitleCanParole = {
                      self = nil,
                      Img_ = nil,
                      Txt_CanRelease = nil
                    },
                    Group_TitleCantParole = {
                      self = nil,
                      Img_ = nil,
                      Txt_CanRelease = nil
                    },
                    Group_CantRelease = {
                      self = nil,
                      Img_ = nil,
                      Group_Prisoner = {
                        self = nil,
                        Img_Prisoner = nil,
                        Group_Num = {
                          self = nil,
                          Img_ = nil,
                          Txt_ = nil
                        },
                        Txt_Name = nil,
                        Txt_Score = nil,
                        Group_Money = {
                          self = nil,
                          Txt_ = nil,
                          Img_Icon = nil,
                          Img_ = nil
                        },
                        Txt_Time = nil,
                        Img_ = nil
                      }
                    },
                    Group_CanRelease = {
                      self = nil,
                      Img_ = nil,
                      Group_Prisoner = {
                        self = nil,
                        Img_Prisoner = nil,
                        Group_Num = {
                          self = nil,
                          Img_ = nil,
                          Txt_ = nil
                        },
                        Txt_Name = nil,
                        Txt_Score = nil,
                        Group_Money = {
                          self = nil,
                          Txt_ = nil,
                          Group_Money = {
                            self = nil,
                            Img_Icon = nil,
                            Txt_Num = nil
                          },
                          Txt_Commission = nil
                        },
                        Txt_Time = nil
                      },
                      Btn_ = {
                        self = nil,
                        Img_ = nil,
                        Txt_ = nil
                      }
                    },
                    Group_NoInfo = {self = nil, Txt_ = nil}
                  }
                }
              }
            },
            Scrollbar_Horizontal = {
              self = nil,
              Sliding_Area = {self = nil, Handle = nil}
            },
            Scrollbar_Vertical = {
              self = nil,
              Sliding_Area = {self = nil, Handle = nil}
            }
          }
        }
      },
      Group_Paixu = {
        self = nil,
        Img_ = nil,
        Img_PaixuSheng = nil,
        Img_PaixuJiang = nil,
        Img_Shaixuan = nil,
        Txt_ = nil,
        Btn_Choose = nil,
        Btn_Paixu = nil,
        Group_Choose = {
          self = nil,
          Img_ = nil,
          Group_Time = {
            self = nil,
            Group_TimeLight = {
              self = nil,
              Img_ = nil,
              Img_Icon = nil,
              Txt_ = nil
            },
            Btn_Time = {
              self = nil,
              Img_ = nil,
              Txt_ = nil
            }
          },
          Group_Score = {
            self = nil,
            Group_ScoreLight = {
              self = nil,
              Img_ = nil,
              Img_Icon = nil,
              Txt_ = nil
            },
            Btn_Score = {
              self = nil,
              Img_ = nil,
              Txt_ = nil
            }
          }
        }
      }
    },
    Group_NoLawyer = {
      self = nil,
      Img_Lawyer = nil,
      Img_Add = nil,
      Txt_ = nil,
      Img_Desk = nil,
      Btn_ = nil
    },
    Group_Lawyer = {
      self = nil,
      Img_Employ = nil,
      Txt_ = nil,
      Img_Pic = nil,
      Img_Desk = nil,
      Img_bg = nil,
      Txt_Name = nil,
      Group_Level = {
        self = nil,
        Txt_ = nil,
        Img_ = nil
      },
      Group_Ability = {
        self = nil,
        Group_Time = {
          self = nil,
          Txt_ = nil,
          Txt_Num = nil,
          Img_ = nil
        },
        Group_MoneyAdd = {
          self = nil,
          Img_ = nil,
          Txt_Des = nil,
          Txt_ = nil
        },
        Group_Money = {
          self = nil,
          Txt_ = nil,
          Group_Cost = {
            self = nil,
            Img_Money = nil,
            Txt_Num = nil
          },
          Group_CostPer = {self = nil, Txt_People = nil}
        }
      },
      Btn_Stop = {self = nil, Txt_ = nil},
      Btn_Employ = {self = nil, Txt_ = nil}
    },
    Btn_All = {self = nil, Txt_ = nil}
  },
  Group_LawyerList = {
    self = nil,
    Img_BG = nil,
    Img_bg = nil,
    Img_Titlebg = nil,
    Group_Title = {
      self = nil,
      Img_Icon = nil,
      Txt_RoomName = nil,
      Group_Refresh = {
        self = nil,
        Img_bg = nil,
        Txt_LowestScore = nil,
        Img_ = nil
      }
    },
    Img_Desk = nil,
    Img_Desk1 = nil,
    Img_Desk2 = nil,
    Group_Lawyer = {
      self = nil,
      Img_Pic = nil,
      Img_bg = nil,
      Txt_Name = nil,
      Group_Level = {
        self = nil,
        Txt_ = nil,
        Img_ = nil
      },
      Group_Ability = {
        self = nil,
        Group_Time = {
          self = nil,
          Txt_ = nil,
          Txt_Num = nil,
          Img_ = nil
        },
        Group_MoneyAdd = {
          self = nil,
          Img_ = nil,
          Txt_Des = nil,
          Txt_ = nil
        },
        Group_Money = {
          self = nil,
          Txt_ = nil,
          Group_Cost = {
            self = nil,
            Img_Money = nil,
            Txt_Num = nil
          },
          Group_CostPer = {self = nil, Txt_People = nil}
        }
      },
      Btn_Stop = {self = nil, Txt_ = nil},
      Btn_Employ = {self = nil, Txt_ = nil}
    },
    StaticGrid_ = {
      self = nil,
      grid = {
        self = nil,
        Img_Pic = nil,
        Img_bg = nil,
        Txt_Name = nil,
        Group_Level = {
          self = nil,
          Txt_ = nil,
          Img_ = nil
        },
        Group_Ability = {
          self = nil,
          Group_Time = {
            self = nil,
            Txt_ = nil,
            Txt_Num = nil,
            Img_ = nil
          },
          Group_MoneyAdd = {
            self = nil,
            Img_ = nil,
            Txt_Des = nil,
            Txt_ = nil
          },
          Group_Money = {
            self = nil,
            Txt_ = nil,
            Group_Cost = {
              self = nil,
              Img_Money = nil,
              Txt_Num = nil
            },
            Group_CostPer = {self = nil, Txt_People = nil}
          }
        },
        Btn_Stop = {self = nil, Txt_ = nil},
        Btn_Employ = {self = nil, Txt_ = nil}
      }
    },
    Group_Refresh = {
      self = nil,
      Img_ = nil,
      Txt_ = nil,
      Img_Diamond = nil,
      Txt_Num = nil
    },
    Btn_Refresh = {
      self = nil,
      Img_ = nil,
      Txt_ = nil
    }
  },
  Group_LawyerSuccess = {
    self = nil,
    Group_Lawyer = {
      self = nil,
      Img_Pic = nil,
      Img_bg = nil,
      Txt_Name = nil,
      Group_Level = {
        self = nil,
        Txt_ = nil,
        Img_ = nil
      },
      Group_Ability = {
        self = nil,
        Group_Time = {
          self = nil,
          Txt_ = nil,
          Txt_Num = nil,
          Img_ = nil
        },
        Group_MoneyAdd = {
          self = nil,
          Img_ = nil,
          Txt_Des = nil,
          Txt_ = nil
        },
        Group_Money = {
          self = nil,
          Txt_ = nil,
          Group_Cost = {
            self = nil,
            Img_Money = nil,
            Txt_Num = nil
          },
          Group_CostPer = {self = nil, Txt_People = nil}
        }
      },
      Btn_Stop = {self = nil, Txt_ = nil},
      Btn_Employ = {self = nil, Txt_ = nil}
    }
  },
  ParoleRoomPrompt = {
    self = nil,
    Img_Blur = nil,
    Group_PrisonDetail = nil,
    Img_BG = nil,
    bg = nil,
    Btn_Confirm = {
      self = nil,
      Group_ = {
        self = nil,
        Img_Icon = nil,
        Txt_Confirm = nil
      }
    },
    Btn_Cancel = {
      self = nil,
      Group_ = {
        self = nil,
        Img_Icon = nil,
        Txt_Cancel = nil
      }
    },
    Group_Item = {
      self = nil,
      Img_PrisonerBG = nil,
      Img_Pic = nil,
      Img_ = nil,
      Group_ID = {
        self = nil,
        Txt_ID = nil,
        Img_Rarity = nil,
        Txt_ = nil
      }
    },
    Txt_Des = nil,
    Txt_Money = nil,
    Img_Zhang = nil
  },
  Group_Tips = {
    self = nil,
    Btn_Close = nil,
    Img_Btm = nil,
    Txt_Tips1 = nil
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
return ParoleRoom
