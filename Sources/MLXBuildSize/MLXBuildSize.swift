import MLX
import MLXFFT
import MLXNN

@discardableResult
public func test() -> MLXArray {
    let arr = MLXArray([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] as [Float])
    _ = MLXFFT.rfft(arr)
    return MLXNN.celu(arr)
}
