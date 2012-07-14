class BreakoutViewController < UIViewController
  BarWidth = 100
  BarHeight = 15
  BallRadius = 10
  BrickRows = 5
  BrickColumns = 7
  BrickPadding = 1
  BrickHeight = 20

  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor

    @playButton = UIButton.alloc.initWithFrame([[view.frame.size.width / 2 - 75, 100], [150, 30]])
    @playButton.setTitle("Play", forState:UIControlStateNormal)
    @playButton.setTitleColor(UIColor.blackColor, forState:UIControlStateNormal)
    @playButton.addTarget(self, action: :startGame, forControlEvents:UIControlEventTouchUpInside)

    view.addSubview(@playButton)
  end

  def startGame
    @playButton.hidden = true

    @bar = UIView.alloc.initWithFrame([[(view.frame.size.width - BarWidth) / 2, view.frame.size.height - BarHeight], [BarWidth, BarHeight]])
    @bar.backgroundColor = UIColor.blueColor

    @barPanGestureRecognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action:"barPanGesture:")
    @bar.addGestureRecognizer(@barPanGestureRecognizer)

    view.addSubview(@bar)

    @ball = UIView.alloc.initWithFrame([[(view.frame.size.width - BallRadius) / 2, (view.frame.size.height - BallRadius) / 2], [BallRadius * 2, BallRadius * 2]])
    @ball.backgroundColor = UIColor.blackColor
    @ball.layer.cornerRadius = BallRadius

    view.addSubview(@ball)

    @balldx = 4
    @balldy = 3

    @brickWidth = view.frame.size.width / BrickColumns - BrickPadding

    @bricks = BrickRows.times.map do |i|
      BrickColumns.times.map do |j|
        UIView.alloc.initWithFrame([[j * (@brickWidth + BrickPadding),
          i * (BrickHeight + BrickPadding)], [@brickWidth, BrickHeight]]).tap do |brick|
          brick.backgroundColor = UIColor.colorWithHue(i.to_f / BrickRows,
            saturation:0.8, brightness:0.8, alpha:1)
          view.addSubview(brick)
        end
      end
    end

    @score = 0

    @timer = NSTimer.scheduledTimerWithTimeInterval(1.0/60, target: self,
      selector: :loop, userInfo: nil, repeats: true)
  end

  def loop
    # Move ball
    width = view.frame.size.width
    height = view.frame.size.height
    frame = @ball.frame

    if frame.origin.y < BrickRows * (BrickPadding + BrickHeight) - 1
      i = frame.origin.y / (BrickPadding + BrickHeight)
      j = frame.origin.x / @brickWidth
      if @bricks[i][j]
        @bricks[i][j].removeFromSuperview
        @bricks[i][j] = nil
        @balldy = - @balldy
        @score += 1
        # Increase speed by 2%
        @balldx *= 1.02
        @balldy *= 1.02
        endGame if won?
      end
    end


    if frame.origin.x + @balldx + BallRadius > width || frame.origin.x + @balldx < 0
      @balldx = - @balldx
    end

    if frame.origin.y + @balldy + BallRadius + BarHeight > height &&
       frame.origin.x > @bar.frame.origin.x &&
       frame.origin.x < @bar.frame.origin.x + BarWidth
        # Ball is within the bar
        @balldy = - @balldy
    elsif frame.origin.y + @balldy + BallRadius * 2 > height
      endGame
    elsif frame.origin.y + @balldy - BallRadius < 0
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

  def endGame
    @timer.invalidate

    alert = UIAlertView.alloc.initWithTitle(won? ? "You Won!" : "Game Over", message:"You scored #{@score} point(s)!",
      delegate:nil, cancelButtonTitle:"Ok", otherButtonTitles:nil)
    alert.show

    # Remove subviews
    @bar.removeFromSuperview
    @ball.removeFromSuperview
    BrickRows.times do |i|
      BrickColumns.times do |j|
        @bricks[i][j] && @bricks[i][j].removeFromSuperview
      end
    end

    @playButton.hidden = false
  end

  def won?
    @score == BrickRows * BrickColumns
  end
end