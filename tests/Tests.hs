module Main where

import Test.Framework (defaultMain, testGroup, Test)
import Test.Framework.Providers.QuickCheck2 (testProperty)

import Test.QuickCheck.Monadic (monadicIO, run)

import System.Posix.IO
import System.Posix.Memory

import Control.Monad
import Control.Exception (bracket)

import Foreign.C.Types
import Foreign.Storable

import Data.Word

psz :: CSize
psz = fromIntegral sysconfPageSize

-- create an anonymous private mapping of page-size size.
withDummyMapping f = do
    bracket (memoryMap Nothing psz [MemoryProtectionRead,MemoryProtectionWrite] MemoryMapPrivate Nothing 0)
            (\mem -> memoryUnmap mem psz)
            f

withDevZeroMapping f = withOpenFd "/dev/zero" $ \fd ->
    bracket (memoryMap Nothing psz [MemoryProtectionRead,MemoryProtectionWrite] MemoryMapPrivate (Just fd) 0)
            (\mem -> memoryUnmap mem psz)
            f
  where withOpenFd filename g = do 
            bracket (openFd filename ReadWrite Nothing defaultFileFlags)
                    closeFd
                    g

tests :: [Test]
tests =
    [ testProperty "page-size" $ sysconfPageSize > 0 && sysconfPageSize < (2^(20::Int))
    , testGroup "anonymous" $ runTestWithMapping withDummyMapping
    , testGroup "fd"        $ runTestWithMapping withDevZeroMapping
    ]
  where runTestWithMapping mapF =
                [ testProperty "mmap-munmap" $ monadicIO $ run $ mapF $ \_ -> return True
                , testProperty "madvise" $ monadicIO $ run $ mapF $ \ptr ->
                    memoryAdvise ptr psz MemoryAdviceRandom >> return True
                , testProperty "msync" $ monadicIO $ run $ mapF $ \ptr ->
                    memorySync ptr psz [MemorySyncAsync] >> return True
                , testProperty "mlock-munlock" $ monadicIO $ run $ mapF $ \ptr -> do
                    memoryLock ptr psz
                    memoryUnlock ptr psz
                    return True
                , testProperty "read" $ monadicIO $ run $ mapF $ \ptr -> do
                    res <- forM [0..(sysconfPageSize-1)] $ \off -> do
                        b <- peekElemOff ptr off :: IO Word8
                        return (b == 0)
                    return $ and res
                ]

main :: IO ()
main = defaultMain tests
