extends TileMap

@export var seed_now = randi()
@export var width = 1024
@export var height = 1024
### for the default
### noises is
### [moisture, temperature, altitude]
@export var noise_dimension = 3
@export var tile_map_size = 4

var noises: Array[Noise] = []
var noise_arrays: Array[Array] = []

func _ready():
    init_noise2()

func init_noise():
    # init noise
    # and init noise array (Array[Array[float]]), float value -> [-1, 1]
    var time_start = Time.get_ticks_msec()
    for d in range(noise_dimension):
        var noise = FastNoiseLite.new()
        noise.seed = seed_now
        var temp_array = []
        for i in range(width):
            var col = []
            for j in range(height):
                col.append(noise.get_noise_2d(i, j))
            temp_array.append(col)
        noise_arrays.append(temp_array)
        noises.append(noise)

    var time_init_end = Time.get_ticks_msec()
    print_debug("init cost time:")
    print_debug(time_init_end - time_start)

    # gen tilemap
    for i in range(width):
        for j in range(height):
            set_cell(0, Vector2i(i, j), 0, Vector2i(_noisy_val_to_int(noise_arrays[0][i][j], tile_map_size), _noisy_val_to_int(noise_arrays[1][i][j], tile_map_size)))
    
    var time_end = Time.get_ticks_msec()
    print_debug("gen tile cost time:")
    print_debug(time_end - time_init_end)

func init_noise2():
    # init noise
    # and init noise array (Array[Array[float]]), float value -> [-1, 1]
    var time_start = Time.get_ticks_msec()
    for d in range(noise_dimension):
        var noise = FastNoiseLite.new()
        noise.seed = seed_now
        var temp_array = []
        temp_array.resize(width)
        for i in range(width):
            var col = []
            col.resize(height)
            for j in range(height):
                col[j] = noise.get_noise_2d(i, j)
            temp_array[i] = col
        noise_arrays.append(temp_array)
        noises.append(noise)

    var time_init_end = Time.get_ticks_msec()
    print_debug("init cost time:")
    print_debug(time_init_end - time_start)

    # gen tilemap
    for i in range(width):
        for j in range(height):
            set_cell(0, Vector2i(i, j), 0, Vector2i(_noisy_val_to_int(noise_arrays[0][i][j], tile_map_size), _noisy_val_to_int(noise_arrays[1][i][j], tile_map_size)))
    
    var time_end = Time.get_ticks_msec()
    print_debug("gen tile cost time:")
    print_debug(time_end - time_init_end)

# convert [-1, 1] -> [0, max_size]
func _noisy_val_to_int(noise_val: float, max_size) -> int:
    # noise_val is [-1, 1]
    var ret_val = (noise_val + 1) / 2 * (max_size + 1) - 0.5
    # ret_val i [0, max_size + 1]
    ret_val = round(ret_val)
    return max_size if ret_val == max_size + 1 else ret_val

