import MLX
import MLXNN

final class AudioEncoder: Module {
    let nMels: Int
    let nCtx: Int
    let nState: Int
    let nHead: Int
    let nLayer: Int
    let dType: MLX.DType

    @ModuleInfo(key: "conv1") private var conv1: Conv1d
    @ModuleInfo(key: "conv2") private var conv2: Conv1d
    @ModuleInfo(key: "blocks") private var blocks: [ResidualAttentionBlock]
    @ModuleInfo(key: "ln_post") private var lnPost: LayerNorm
    private let _positionalEmbedding: MLXArray

    init(
        nMels: Int,
        nCtx: Int,
        nState: Int,
        nHead: Int,
        nLayer: Int,
        dType: MLX.DType = .float16
    ) {
        self.nMels = nMels
        self.nCtx = nCtx
        self.nState = nState
        self.nHead = nHead
        self.nLayer = nLayer
        self.dType = dType

        self._conv1.wrappedValue = Conv1d(
            inputChannels: nMels, outputChannels: nState, kernelSize: 3, padding: 1)
        self._conv2.wrappedValue = Conv1d(
            inputChannels: nState, outputChannels: nState, kernelSize: 3, stride: 2, padding: 1)
        self._blocks.wrappedValue = (0..<nLayer).map { _ in
            ResidualAttentionBlock(nState: nState, nHead: nHead)
        }
        self._lnPost.wrappedValue = LayerNorm(dimensions: nState)
        self._positionalEmbedding = sinusoids(length: nCtx, channels: nState).asType(dType)
    }

    func callAsFunction(_ x: MLXArray) -> MLXArray {
        var x = MLXNN.gelu(conv1(x))
        x = MLXNN.gelu(conv2(x))
        assert(Array(x.shape[1...]) == _positionalEmbedding.shape, "incorrect audio shape")
        x = x + _positionalEmbedding
        for block in blocks {
            x = block(x).x
        }
        x = lnPost(x)
        return x
    }
}
