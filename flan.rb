require 'formula'

class Flann < Formula
  url 'http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.6.11-src.zip'
  homepage 'http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN'
  md5 '5fd889b9f3777aa6e0d05b2546d25eb5'

  option 'enable-python', 'Enable python bindings'
  option 'enable-matlab', 'Enable matlab/octave bindings'
  option 'with-examples', 'Build and install example binaries'

  depends_on 'cmake' => :build
  depends_on 'hdf5'

  depends_on 'octave' if build.include? 'enable-matlab'
  depends_on 'numpy' => :python if build.include? 'enable-python'

  def install
    args = std_cmake_args
    if build.include? 'enable-matlab'
      args << '-DBUILD_MATLAB_BINDINGS:BOOL=ON'
    else
      args << '-DBUILD_MATLAB_BINDINGS:BOOL=OFF'
    end

    if build.include? 'enable-python'
      args << '-DBUILD_PYTHON_BINDINGS:BOOL=ON'
    else
      args << '-DBUILD_PYTHON_BINDINGS:BOOL=OFF'
    end

    inreplace 'CMakeLists.txt', 'add_subdirectory( examples )', '' unless build.include? 'with-examples'

    mkdir 'build' do
      system 'cmake', '..', *args
      system 'make install'
    end
  end
end
