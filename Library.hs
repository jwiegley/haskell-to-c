{-# LANGUAGE ForeignFunctionInterface #-}

module Library where

import Foreign.C.Types
import Foreign.C.String
import System.IO.Unsafe

foreign export ccall c_sampleMethod :: CInt -> CString

c_sampleMethod :: CInt -> CString
c_sampleMethod n = unsafePerformIO $ do
    let s = sampleMethod (fromIntegral n)
    newCString s

sampleMethod :: Int -> String
sampleMethod = show
