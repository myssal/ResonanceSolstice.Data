local MiniGameBS = {
  self = nil,
  Img_Background = nil,
  Group_Scene = {
    self = nil,
    Group_Ground = {self = nil, Img_Ground = nil},
    Img_Blood = nil,
    Group_Depth = {
      self = nil,
      Group_Mary = {self = nil, Img_Actor = nil},
      Img_Plant1 = nil,
      Img_Plant2 = nil,
      Img_Plant3 = nil,
      Img_Plant4 = nil,
      Img_Plant5 = nil,
      Img_Plant6 = nil,
      Img_FenceLeft = nil,
      Img_FenceRight = nil,
      Group_Gate = {self = nil, Img_Gate = nil},
      Group_Grimm = {
        self = nil,
        Img_Shadow_Placeholder = nil,
        Img_Actor = nil
      }
    },
    Group_HitEffect = {self = nil, Img_Spark_Placeholder = nil}
  },
  Group_Controls = {
    self = nil,
    Btn_Return = {self = nil, Img_Icon = nil},
    Btn_Rank = {
      self = nil,
      Txt_Label = nil,
      Img_Icon = nil
    },
    Group_Direction = {
      self = nil,
      Btn_Up = {self = nil, Img_Icon = nil},
      Btn_Left = {self = nil, Img_Icon = nil},
      Btn_Down = {self = nil, Img_Icon = nil},
      Btn_Right = {self = nil, Img_Icon = nil}
    },
    Btn_Interact = {self = nil, Txt_Label = nil}
  },
  Group_Choices = {
    self = nil,
    Img_Frame = nil,
    Btn_Punch = {
      self = nil,
      Img_Selected = nil,
      Txt_Label = nil
    },
    Btn_Kill = {
      self = nil,
      Img_Selected = nil,
      Txt_Label = nil
    },
    Btn_Special = {
      self = nil,
      Img_Selected = nil,
      Img_Mosaic = nil
    },
    Btn_Leave = {
      self = nil,
      Img_Selected = nil,
      Txt_Label = nil
    }
  },
  Group_Dialogue = {
    self = nil,
    Btn_DialogueArea = nil,
    Img_Frame = nil,
    Img_Portrait = nil,
    Txt_Speaker = nil,
    Txt_Content = nil,
    Btn_Advance = {
      self = nil,
      Img_Icon = nil,
      Txt_Label = nil
    }
  },
  Group_Victory = {
    self = nil,
    Img_Band = nil,
    Txt_Title = nil,
    Txt_Subtitle = nil
  },
  Img_Flash = nil,
  Group_Loading = {
    self = nil,
    Img_Mask = nil,
    Txt_Status = nil
  }
}
return MiniGameBS
