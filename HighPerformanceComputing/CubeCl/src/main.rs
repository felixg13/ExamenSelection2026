use cubecl::prelude::*;

// This function will be executed in parallel on the GPU/CPU
// Lookup the variable ABSOLUTE_POS to get started!
#[cube(launch_unchecked)]
fn compute_bbf<F: Float>(max_iter: u32, vec_size: u32, output: &mut Array<f32>) {
    if max_iter < ABSOLUTE_POS as u32 {
        terminate!();
    }
    let k = ABSOLUTE_POS as i32;
    let hk = 8 * k;
    // └──── E0599: no method named `__expand_powi_method` found for type `i32` in the current scope
    // CubeCL pas googlable fuck this
    let result = 1 // (1 / 16_i32.powi(k)) as i32
        * ((4 / (hk + 1)) - (2 / (hk + 4)) - (1 / (hk + 5)) - (1 / (hk + 6)));
    output[ABSOLUTE_POS] = result as f32;
}

pub fn launch<R: Runtime>(device: &R::Device) {
    let vectorization = 4usize;
    let max_iter = 1000_00_000u32;
    let client = R::client(device);
    let output_handle = client.empty(max_iter as usize * core::mem::size_of::<f32>());

    unsafe {
        compute_bbf::launch_unchecked::<f32, R>(
            &client,
            CubeCount::Static(1, 1, 1),
            CubeDim::new_1d(vectorization as u32),
            ScalarArg::new(max_iter),
            ScalarArg::new(4),
            ArrayArg::from_raw_parts::<f32>(&output_handle, max_iter as usize, vectorization),
        )
        .unwrap()
    };

    let bytes = client.read_one(output_handle);

    let output = f32::from_bytes(&bytes);

    // let result = output.iter().sum<f32>();
    let result: f32 = output.iter().sum();
    println!("{:?}", output);

    println!("Answer => {result}",);
}

fn launch_cubcl() {
    #[cfg(feature = "cuda")]
    {
        print!("Launching with CUDA runtime...\n");
        launch::<cubecl::cuda::CudaRuntime>(&Default::default());
    }

    #[cfg(feature = "wgpu")]
    {
        print!("Launching with WGPU runtime...\n");
        launch::<cubecl::wgpu::WgpuRuntime>(&Default::default());
    }

    #[cfg(feature = "cpu")]
    {
        print!("Launching with CPU runtime...\n");
        launch::<cubecl::cpu::CpuRuntime>(&Default::default());
    }
}

fn main() {
    println!("Bailey-Borwein-Plouffe with cubecl!");
    launch_cubcl();
}
