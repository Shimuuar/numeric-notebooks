-- |
{-# LANGUAGE TemplateHaskell #-}
module NB.Heatmap (
    HeatMap(..)
  , heat_map_color_map
  , heat_map_zrange
  , heat_map_values
    -- * Colormaps
  , greyColormap
  , blackbodyColormap
  ) where

import Control.Lens
import Control.Arrow (Arrow(..))
import Control.Applicative
import Control.Monad

import Data.Default.Class
import Data.Maybe

import Graphics.Rendering.Chart.Easy
import NB.Colormap


data HeatMap z x y = HeatMap
  { _heat_map_color_map :: Double -> AlphaColour Double
  , _heat_map_zrange   :: (Maybe z, Maybe z)
  , _heat_map_values    :: [((x,y),(x,y),z)]  
  }

instance Default (HeatMap z x y) where
  def =  HeatMap
    { _heat_map_color_map = blackbodyColormap
    , _heat_map_zrange    = (Nothing, Nothing)
    , _heat_map_values    = []
    }
  
instance (PlotValue z) => ToPlot (HeatMap z) where
  toPlot p = Plot
    { _plot_render     = renderHeatMap p
    , _plot_legend     = []
    , _plot_all_points = ( (\((x1,_),(x2,_),_) -> [x1,x2]) =<< _heat_map_values p
                         , (\((_,y1),(_,y2),_) -> [y1,y2]) =<< _heat_map_values p )
    }
                  
renderHeatMap  :: (PlotValue z) =>
                  HeatMap z x y -> PointMapFn x y -> ChartBackend ()
renderHeatMap p pmap = forM_ (_heat_map_values p) $ \((x1,y1),(x2,y2),z) -> do
  let corner1 = pmap (LValue x1, LValue y1) 
      corner2 = pmap (LValue x2, LValue y2) 
      path    = rectPath $ Rect corner1 corner2
      zval    = toValue z
      zColor  = (zval - zMin) / (zMax - zMin)
  withFillStyle (FillStyleSolid $ _heat_map_color_map p zColor) $
      fillPath path
  where    
    zs   = [zv | (_,_,z) <- _heat_map_values p 
               , let zv = toValue z 
               , not $ isInfinite zv || isNaN zv
           ]
    (userZMin,userZMax) = (fmap toValue *** fmap toValue)
                        $ _heat_map_zrange p
    (dataZMin,dataZMax) = case zs of
      [] -> (Nothing,Nothing)
      _  -> (Just $ minimum zs, Just $ maximum zs)
    zMin = fromMaybe 0 $ userZMin <|> dataZMin
    zMax = fromMaybe 0 $ userZMax <|> dataZMax

makeLenses ''HeatMap
