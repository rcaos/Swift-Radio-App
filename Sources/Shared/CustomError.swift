import Foundation
import NetworkingInterface

public enum CustomError: Error {
  case genericError
  case transferError(DataTransferError)
}
