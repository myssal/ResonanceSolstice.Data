local MedicalRoom = {
  self = nil,
  Img_BG = nil,
  Img_Mask = nil,
  Img_Blur = nil,
  Img_bg = nil,
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
  Group_GoldCoin = {
    self = nil,
    Img_BG = nil,
    Btn_GoldCoin = nil,
    Img_Icon = nil,
    Txt_Num = nil,
    Btn_Add = nil
  },
  Group_Title = {
    self = nil,
    Img_ = nil,
    Txt_Level = nil,
    Img_Icon = nil,
    Txt_RoomName = nil,
    Group_LevelName = {
      self = nil,
      Img_BG = nil,
      Txt_LevelName = nil
    }
  },
  Btn_Report = {
    self = nil,
    Img_AP = {
      self = nil,
      Img_ = nil,
      Txt_ = nil
    }
  },
  Group_Detail = {
    self = nil,
    Group_Line = {
      self = nil,
      Img_bg = nil,
      Txt_Line = nil,
      Txt_LineNum = nil,
      Img_ = nil,
      Img_Prisoner = nil
    },
    Group_Patient = {
      self = nil,
      Img_bg = nil,
      Img_Icon = nil,
      Txt_Patient = nil,
      Txt_PatientNum = nil
    }
  },
  Group_MedicalRoom = {
    self = nil,
    NewScrollGrid_ = {
      self = nil,
      grid = {
        self = nil,
        Group_NoBed = {self = nil, Img_BGNoBed = nil},
        Group_Bed = {
          self = nil,
          Img_BGBed = nil,
          Group_Prisoner = {
            self = nil,
            Group_Prisoner = {self = nil, Spine_ = nil},
            Group_CureTime = {
              self = nil,
              Img_ = nil,
              Group_Bar = {
                self = nil,
                Txt_Time = nil,
                Group_Bar = {
                  self = nil,
                  Img_BG = nil,
                  Img_Bar = nil
                },
                Img_ = nil
              }
            },
            Group_Line = {
              self = nil,
              Group_Line = {
                self = nil,
                Img_ = nil,
                Txt_ = nil
              },
              Group_Bed = {self = nil, Txt_ = nil}
            },
            Group_Card = {
              self = nil,
              Img_bg = nil,
              Group_Detail = {
                self = nil,
                Txt_Name = nil,
                Txt_Num = nil,
                Group_Medical = {
                  self = nil,
                  Img_Icon = nil,
                  Txt_HealthNum = nil
                },
                Group_Health = {
                  self = nil,
                  Txt_Health = nil,
                  Txt_HealthNum = nil
                },
                Group_CureHealth = {
                  self = nil,
                  Txt_Health = nil,
                  Txt_HealthNum = nil
                }
              }
            }
          },
          Group_Bed = {self = nil, Txt_ = nil},
          Btn_ = nil
        }
      }
    }
  },
  Group_Report = {
    self = nil,
    Img_Mask = nil,
    Btn_Close = nil,
    Img_BGFrame = nil,
    Group_Title = {
      self = nil,
      Txt_ = nil,
      Img_ = nil,
      Txt_EN = nil,
      Txt_Des = nil
    },
    Group_Report = {
      self = nil,
      ScrollView_ = {
        self = nil,
        Viewport = {
          self = nil,
          Content = {
            self = nil,
            Group_Cure = {
              self = nil,
              Group_Title = {
                self = nil,
                Img_ = nil,
                Txt_Cure = nil
              },
              Group_Cure = {
                self = nil,
                Img_ = nil,
                Group_Time = {
                  self = nil,
                  Txt_Time = nil,
                  Txt_TimeNum = nil,
                  Img_ = nil
                },
                Group_Des = {
                  self = nil,
                  Txt_Des = nil,
                  Group_Pain = {
                    self = nil,
                    Img_Icon = nil,
                    Txt_Name = nil
                  }
                },
                Group_Prisoner = {
                  self = nil,
                  Img_Prisoner = nil,
                  Group_Num = {
                    self = nil,
                    Img_ = nil,
                    Txt_ = nil
                  },
                  Img_ = nil
                }
              },
              StaticGrid_Punish = {
                self = nil,
                grid = {
                  self = nil,
                  Img_ = nil,
                  Group_Time = {
                    self = nil,
                    Txt_Time = nil,
                    Txt_TimeNum = nil,
                    Img_ = nil
                  },
                  Group_Des = {
                    self = nil,
                    Txt_Des = nil,
                    Group_Pain = {
                      self = nil,
                      Img_Icon = nil,
                      Txt_Name = nil
                    }
                  },
                  Group_Prisoner = {
                    self = nil,
                    Img_Prisoner = nil,
                    Group_Num = {
                      self = nil,
                      Img_ = nil,
                      Txt_ = nil
                    },
                    Img_ = nil
                  }
                }
              },
              Group_NoInfo = {self = nil, Txt_NoInfo = nil}
            },
            Group_Release = {
              self = nil,
              Group_Title = {
                self = nil,
                Img_ = nil,
                Txt_Release = nil
              },
              Group_Release = {
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
                  Img_ = nil
                },
                Group_Release = {
                  self = nil,
                  Img_ = nil,
                  Txt_ = nil
                }
              },
              StaticGrid_Punish = {
                self = nil,
                grid = {
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
                    Img_ = nil
                  },
                  Group_Release = {
                    self = nil,
                    Img_ = nil,
                    Txt_ = nil
                  }
                }
              },
              Group_NoInfo = {self = nil, Txt_NoInfo = nil}
            },
            Group_Finish = {
              self = nil,
              Img_Line = nil,
              Group_Tips = {
                self = nil,
                Img_ = nil,
                Txt_ = nil,
                Txt_Des = nil
              },
              Group_Finish = {
                self = nil,
                Img_Complete = nil,
                Img_Zhang = nil,
                Txt_Finish = nil
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
  Img_BianLeft = nil,
  Img_BianRight = nil
}
return MedicalRoom
