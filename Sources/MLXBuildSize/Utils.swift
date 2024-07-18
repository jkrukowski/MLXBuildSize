import Foundation
import MLX
import MLXNN

extension Embedding {
    func asLinear(_ x: MLXArray) -> MLXArray {
        x.matmul(weight.T)
    }
}

func additiveCausalMask(_ n: Int, dType: MLX.DType = .float32) -> MLXArray {
    let indices = MLXArray(Array(0..<n))
    let mask = indices[0..., .newAxis] .< indices[.newAxis]
    return mask.asType(dType) * -1e9
}

func sinusoids(length: Int, channels: Int, maxTimescale: Int = 10000) -> MLXArray {
    assert(channels % 2 == 0)
    let logTimescaleIncrement = log(Float(maxTimescale)) / Float(channels / 2 - 1)
    let invTimescales = MLX.exp(-logTimescaleIncrement * MLXArray(Array(0..<(channels / 2))))
    let scaledTime =
        MLXArray(Array(0..<length)).reshaped([length, 1])
        * invTimescales.reshaped([1, channels / 2])
    return MLX.concatenated([MLX.sin(scaledTime), MLX.cos(scaledTime)], axis: 1)
}

func loadParameters(at url: URL) throws -> NestedDictionary<String, MLXArray> {
    let arrays = try MLX.loadArrays(url: url)
    return ModuleParameters.unflattened(arrays)
}

func loadConfig(at url: URL) throws -> MLXModelConfig {
    let configDecoder = JSONDecoder()
    configDecoder.keyDecodingStrategy = .convertFromSnakeCase
    return try configDecoder.decode(MLXModelConfig.self, from: Data(contentsOf: url))
}
