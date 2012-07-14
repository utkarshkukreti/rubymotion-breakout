class BreakoutViewController < UIViewController
  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor

    width = 100
    height = 15
    @bar = UIView.alloc.initWithFrame([[(view.frame.size.width - width) / 2, view.frame.size.height - height], [width, height]])
    @bar.backgroundColor = UIColor.blueColor

    @barPanGestureRecognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action:"barPanGesture:")
    @bar.addGestureRecognizer(@barPanGestureRecognizer)

    view.addSubview(@bar)

    radius = 10
    @ball = UIView.alloc.initWithFrame([[(view.frame.size.width - radius) / 2, (view.frame.size.height - radius) / 2], [radius * 2, radius * 2]])
    @ball.backgroundColor = UIColor.blackColor
    @ball.layer.cornerRadius = radius

    view.addSubview(@ball)

    @balldx = 4
    @balldy = 3

    @timer = NSTimer.scheduledTimerWithTimeInterval(1.0/60, target: self,
      selector: :loop, userInfo: nil, repeats: true)
  end

  def loop
    # Move ball
    width = view.frame.size.width
    height = view.frame.size.height
    frame = @ball.frame
    radius = frame.size.width / 2

    if frame.origin.x + @balldx + radius > width || frame.origin.x + @balldx < 0
      @balldx = - @balldx
    end
    if frame.origin.y + @balldy + radius > height || frame.origin.y + @balldy < 0
      @balldy = - @balldy
    end

    frame.origin.x += @balldx
    frame.origin.y += @balldy
    @ball.frame = frame
  end

  def barPanGesture(sender)
    point = sender.translationInView(@bar)
    sender.setTranslation([0, 0], inView:@bar)
    frame = @bar.frame
    frame.origin.x += point.x

    if frame.origin.x < 0
      frame.origin.x = 0
    elsif frame.origin.x > view.frame.size.width - frame.size.width
      frame.origin.x = view.frame.size.width - frame.size.width
    end

    @bar.frame = frame
  end
end