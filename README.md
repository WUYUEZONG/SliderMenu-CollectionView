# SliderMenu-CollectionView
滑动菜单和CollectionView的组合


SliderMenu 的简单使用

        sliderMenu = SliderMenuView.init(frame: CGRectMake(0, 20, self.view.frame.width, 44))
        // 数据
        sliderMenu.titles = ["你","好","Swift","编程","之","美","新生","梦","想"]
        // 点击事件代理
        sliderMenu.delegate = self
                
                protocol SliderMenuViewDelegate {
                      func didSelectedAtIndex(index: NSInteger , animated: Bool)
                }

        // 设置初始位置
        sliderMenu.index = 3
