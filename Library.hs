{-# LANGUAGE ForeignFunctionInterface #-}

module Library where

import           Data.Foldable
import qualified Data.Vector.Storable as SV
import           Foreign.C.String
import           Foreign.C.Types
import           Foreign.Ptr
import           Foreign.ForeignPtr
import           Foreign.StablePtr
import           Foreign.Storable
import           MainIntf
import           System.IO.Unsafe

foreign export ccall c_initState :: CInt -> IO (Ptr ())
foreign export ccall c_freeState :: Ptr () -> IO ()
foreign export ccall c_processTrack :: Ptr C'Track -> Ptr () -> Ptr (Ptr ()) -> IO CString
foreign export ccall c_sampleMethod :: CInt -> Ptr () -> Ptr (Ptr ()) -> CString

c_initState :: CInt -> IO (Ptr ())
c_initState n = castStablePtrToPtr <$> newStablePtr n

c_processTrack :: Ptr C'Track -> Ptr () -> Ptr (Ptr ()) -> IO CString
c_processTrack trackPtr st res = do
    let v = castPtrToStablePtr st :: StablePtr Int
    st' <- deRefStablePtr v
    track <- peek trackPtr
    fpoints <- newForeignPtr_ (c'Track'points track)
    let vec = SV.unsafeFromForeignPtr0 fpoints 1
    let (str', st'''') = (\f -> foldl' f ("", st') (SV.toList vec)) $ \(acc, st'') n ->
            let (str', st''') = processTrack (fromIntegral (c'Point'moment n)) st'' in
            (acc ++ str', st''')
    str'' <- newCString str'
    freeStablePtr v
    v' <- newStablePtr st''''
    poke res (castStablePtrToPtr v')
    return str''

c_freeState :: Ptr () -> IO ()
c_freeState st = freeStablePtr (castPtrToStablePtr st)

processTrack :: Int -> Int -> (String, Int)
processTrack x y = (show x ++ ":" ++ show y, y + 1)

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
