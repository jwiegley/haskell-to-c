{-# LANGUAGE ForeignFunctionInterface #-}

module Library where

import Foreign.Ptr
import Foreign.StablePtr
import Foreign.C.Types
import Foreign.C.String
import Foreign.Storable
import System.IO.Unsafe

foreign export ccall c_initState :: CInt -> Ptr ()
foreign export ccall c_sampleMethod :: CInt -> Ptr () -> Ptr (Ptr ()) -> CString

c_initState :: CInt -> Ptr ()
c_initState n = castStablePtrToPtr $ unsafePerformIO $ newStablePtr n

c_sampleMethod :: CInt -> Ptr () -> Ptr (Ptr ()) -> CString
c_sampleMethod n st res = unsafePerformIO $ do
    let v = castPtrToStablePtr st :: StablePtr Int
    st' <- deRefStablePtr v
    let (str, n') = sampleMethod (fromIntegral n) st'
    str' <- newCString str
    freeStablePtr v
    v' <- newStablePtr n'
    poke res (castStablePtrToPtr v')
    return str'

sampleMethod :: Int -> Int -> (String, Int)
sampleMethod x y = (show x ++ ":" ++ show y, y + 1)
