{-# OPTIONS_GHC -fno-warn-unused-imports #-}

#include <bindings.dsl.h>
#include "main.h"

module MainIntf where

import Foreign.Ptr
import qualified Data.Vector.Storable as SV

#strict_import

#starttype struct Point
#field moment , CLong
#field latitude , CDouble
#field longitude , CDouble
#stoptype

#starttype struct Track
#field points , Ptr <Point>
#stoptype
