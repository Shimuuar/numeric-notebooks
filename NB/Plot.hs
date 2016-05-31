-- |
module NB.Plot where

import Numeric.MathFunctions.Comparison
import Graphics.Rendering.Chart.Easy

-- | List of uniformly spaced points
linspace :: (Double,Double) -> Int -> [Double]
linspace (a,b) n = [a + (b - a) * fromIntegral i / fromIntegral n           | i <- [0 .. n]]

-- | List of uniformly spaced points
linspaceIntervals :: (Double,Double) -> Int -> [(Double,Double,Double)]
linspaceIntervals (a,b) n
  = [ (x, x+d, x + 2*d)
    | i <- [0 .. n-1]
    , let x = a + (b - a) * fromIntegral i / fromIntegral n
    ]
  where
    d = (b - a) / (2 * fromIntegral n)

-- | List of uniformly spaced points in log space
logspace :: (Double,Double) -> Int -> [Double]
logspace (a,b) n
  = [ case () of
        _| i == 0    -> a
         | i == n    -> b
         | otherwise -> exp $ la + (lb - la) * fromIntegral i / fromIntegral n
    | i <- [0 .. n]]
  where la = log a
        lb = log b

-- Generate list of points 
funcPoints :: RealFloat a => (Double -> a) -> (Double, Double) -> Int -> [(Double, a)]
funcPoints f (a,b) n =
  [(x,y) | x <- linspace (a,b) n
         , let y = f x
         , not (isInfinite y)
         , not (isNaN y)
  ]

funcPointsLog :: RealFloat a => (Double -> a) -> (Double, Double) -> Int -> [(LogValue, a)]
funcPointsLog f (a,b) n =
  [(LogValue x,y) | x <- logspace (a,b) n
                  , let y = f x
                  , not (isInfinite y)
                  , not (isNaN y)
  ]


-- | Plot list of functions
plotFunctions :: (RealFloat y, PlotValue y) => [Double -> y] -> (Double, Double) -> Layout Double y
plotFunctions funs rng
  = layout_plots .~
      [ toPlot $ plot_lines_values .~ [funcPoints fun rng 1000]
               $ plot_lines_style  .~ (line_color .~ opaque color $ def)
               $ def
      | (color,fun) <- cycle [blue,red,green] `zip` funs
      ]
  $ def

-- | Plot list of functions in log domain
plotFunctionsLog :: (RealFloat y, PlotValue y) => [Double -> y] -> (Double, Double) -> Layout LogValue y
plotFunctionsLog funs rng
  = layout_plots .~
      [ toPlot $ plot_lines_values .~ [funcPointsLog fun rng 1000]
               $ plot_lines_style  .~ (line_color .~ opaque color $ def)
               $ def
      | (color,fun) <- cycle [blue,red,green] `zip` funs
      ]
  $ def


ulpPlot :: [Double -> Double] -> Double -> Int -> Layout Int Int
ulpPlot funs x0 n
  = layout_plots .~
      [ toPlot $ plot_lines_values .~ [points fun]
               $ plot_lines_style  .~ (line_color .~ opaque color $ def)
               $ def
      | (fun,color) <- funs `zip` cycle [blue,red,green]
      ]
  $ def 
  where
    y0  = minimum $ map ($ x0) funs
    points f = [ ( i
               , fromIntegral $ ulpDistance y0 $ f (addUlps (fromIntegral i) x0))
               | i <- [0 .. n]]
