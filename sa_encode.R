#===============================================================================
# AlloHubMat::sa_encode.R
# Encode a protein structure as structural string
# (C) 2019 Franca Fraternali, Jens Kleinjung, Jamie Macpherson
#
# This file is part of AlloHubMat.
#
#    AlloHubMat is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Foobar is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
#'
#' Encode a protein structure with the M32K25 structural alphabet.
#'
#' Given a PDB structure and trajectory, this function will fit C-alpha
#' coordinates of all consecutive 4-residue fragments with the canonical
#' fragments of the M32K25 structural alphabet, selecting the optimal
#' (lowest RMSD) fragment in each case.
#' The function returns an 'sadata' object with the encoded trajectory as
#' structural string alignment in the 'sa_trajectory' slot.
#===============================================================================

#_______________________________________________________________________________
## assign the M32K25 structural alphabet
.assign_M32K25 = function(sadata_o) {
  ## fragment letters
  sadata_o@fragment_letters = c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y');

  ## fragment coordinates
  sadata_o@fragment_coordinates = list(
    matrix( c( c(  2.630,  11.087,-12.054), c(  2.357,  13.026,-15.290), c(  1.365,  16.691,-15.389), c(  0.262,  18.241,-18.694)), byrow = TRUE, nrow = 4, ncol=3), #A
    matrix( c( c(  9.284,  15.264, 44.980), c( 12.933,  14.193, 44.880), c( 14.898,  12.077, 47.307), c( 18.502,  10.955, 47.619)), byrow = TRUE, nrow = 4, ncol=3), #B
    matrix( c( c(-25.311,  23.402, 33.999), c(-23.168,  25.490, 36.333), c(-23.449,  24.762, 40.062), c( -23.266, 27.976, 42.095)), byrow = TRUE, nrow = 4, ncol=3), #C
    matrix( c( c( 23.078,   3.265, -5.609), c( 21.369,   6.342, -4.176), c( 20.292,   6.283, -0.487), c( 17.232,   7.962,  1.027)), byrow = TRUE, nrow = 4, ncol=3), #D
    matrix( c( c( 72.856,  22.785, 26.895), c( 70.161,  25.403, 27.115), c( 70.776,  28.306, 29.539), c( 69.276,  31.709, 30.364)), byrow = TRUE, nrow = 4, ncol=3), #E
    matrix( c( c( 41.080,  47.709, 33.614), c( 39.271,  44.390, 33.864), c( 36.049,  44.118, 31.865), c( 32.984,  43.527, 34.064)), byrow = TRUE, nrow = 4, ncol=3), #F
    matrix( c( c( 59.399,  59.100, 40.375), c( 57.041,  57.165, 38.105), c( 54.802,  54.093, 38.498), c( 54.237,  51.873, 35.502)), byrow = TRUE, nrow = 4, ncol=3), #G
    matrix( c( c( -1.297,  14.123,  7.733), c(  1.518,  14.786,  5.230), c(  1.301,  17.718,  2.871), c( -0.363,  16.930, -0.466)), byrow = TRUE, nrow = 4, ncol=3), #H
    matrix( c( c( 40.106,  24.098, 63.681), c( 40.195,  25.872, 60.382), c( 37.528,  27.160, 58.053), c( 37.489,  25.753, 54.503)), byrow = TRUE, nrow = 4, ncol=3), #I
    matrix( c( c( 25.589,   1.334, 11.216), c( 27.604,   1.905, 14.443), c( 30.853,  -0.042, 14.738), c( 30.051,  -1.020, 18.330)), byrow = TRUE, nrow = 4, ncol=3), #J
    matrix( c( c( 17.239,  71.346, 65.430), c( 16.722,  74.180, 67.850), c( 18.184,  77.576, 67.092), c( 20.897,  77.030, 69.754)), byrow = TRUE, nrow = 4, ncol=3), #K
    matrix( c( c( 82.032,  25.615,  4.316), c( 81.133,  23.686,  7.493), c( 83.903,  21.200,  8.341), c( 81.485,  19.142, 10.443)), byrow = TRUE, nrow = 4, ncol=3), #L
    matrix( c( c( 28.972,  -1.893, -7.013), c( 28.574,  -5.153, -5.103), c( 30.790,  -7.852, -6.647), c( 30.144, -10.746, -4.275)), byrow = TRUE, nrow = 4, ncol=3), #M
    matrix( c( c( -4.676,  72.183, 52.250), c( -2.345,  71.237, 55.105), c(  0.626,  71.396, 52.744), c(  1.491,  72.929, 49.374)), byrow = TRUE, nrow = 4, ncol=3), #N
    matrix( c( c(  0.593,  -3.290,  6.669), c(  2.032,  -2.882,  3.163), c(  4.148,  -6.042,  3.493), c(  7.276,  -4.148,  2.496)), byrow = TRUE, nrow = 4, ncol=3), #O
    matrix( c( c( 29.683,  47.318, 25.490), c( 26.781,  47.533, 27.949), c( 26.068,  51.138, 26.975), c( 27.539,  52.739, 30.088)), byrow = TRUE, nrow = 4, ncol=3), #P
    matrix( c( c( 34.652,  36.550, 18.964), c( 33.617,  37.112, 15.311), c( 32.821,  40.823, 15.695), c( 34.062,  43.193, 12.979)), byrow = TRUE, nrow = 4, ncol=3), #Q
    matrix( c( c(  8.082,  44.667, 15.947), c(  5.161,  46.576, 17.520), c(  5.855,  49.813, 15.603), c(  3.022,  50.724, 13.161)), byrow = TRUE, nrow = 4, ncol=3), #R
    matrix( c( c( 64.114,  65.465, 28.862), c( 63.773,  68.407, 26.422), c( 67.481,  69.227, 26.232), c( 67.851,  68.149, 22.610)), byrow = TRUE, nrow = 4, ncol=3), #S
    matrix( c( c(-18.708,-123.580,-46.136), c(-18.724,-126.113,-48.977), c(-18.606,-123.406,-51.661), c(-14.829,-123.053,-51.400)), byrow = TRUE, nrow = 4, ncol=3), #T
    matrix( c( c( 61.732,  49.657, 35.675), c( 62.601,  46.569, 33.613), c( 65.943,  46.199, 35.408), c( 64.205,  46.488, 38.806)), byrow = TRUE, nrow = 4, ncol=3), #U
    matrix( c( c( 88.350,  40.204, 52.963), c( 86.971,  39.540, 49.439), c( 85.732,  36.159, 50.328), c( 83.085,  37.796, 52.614)), byrow = TRUE, nrow = 4, ncol=3), #V
    matrix( c( c( 23.791,  23.069,  3.102), c( 26.051,  22.698,  6.166), c( 23.278,  21.203,  8.349), c( 21.071,  19.248,  5.952)), byrow = TRUE, nrow = 4, ncol=3), #W
    matrix( c( c(  1.199,   3.328, 36.383), c(  1.782,   3.032, 32.641), c(  1.158,   6.286, 30.903), c(  1.656,   8.424, 34.067)), byrow = TRUE, nrow = 4, ncol=3), #X
    matrix( c( c( 33.001,  12.054,  8.400), c( 35.837,  11.159, 10.749), c( 38.009,  10.428,  7.736), c( 35.586,   7.969,  6.163)), byrow = TRUE, nrow = 4, ncol=3) #Y
  )
  names(sadata_o@fragment_coordinates) = sadata_o@fragment_letters;

  return(sadata_o);
}

#_______________________________________________________________________________
.encode = function(traj.xyz, fragment.letters, fragment.coordinates) {
#	  if(str.format == 'pdb'){
	    ## parse pdb file coordinates into matrices of four sequential Calpha coordinates
	    ## index vector of Calpha atom
#      ca.ix = bio3d::atom.select(pdbfile, "calpha");
	    ## matrix of x,y,z coordinates of all Calpha atoms
#	    ca.xyz = pdbfile$atom[ca.ix$atom, c("x","y","z")];
#	} else if(str.format == 'dcd'){
#      ca_xyz = traj.xyz
#	} else {
#		stop(paste("structure extension", str.format, "not supported"));
#	}

  ## create index matrix to fragment-subset coordinate matrix
	## each matrix column corresponds to a 4-Calpha fragment of the input structure
  nFs = dim(traj.xyz)[1] - 3;
	fs_m = matrix(nrow = 4, ncol = nFs);
	## index vector from 1 to (length-3)
	fs_ix = seq(1:(dim(traj.xyz)[1] - 3));
	## assign index vectors and the corresponding +1:3 incremental vectors
	fs_m[1, ] = fs_ix;
	fs_m[2, ] = fs_ix + 1;
	fs_m[3, ] = fs_ix + 2;
	fs_m[4, ] = fs_ix + 3;

	## fit all input structure fragments to all alphabet fragments
	rmsd_m = apply(fs_m, 2, function(x) {
		sapply(1:length(fragment.coordinates), function(y) {
			kabsch(traj.xyz[x, ], fragment.coordinates[[y]]);
		});
	});
	## vector of minimal rmsd values
	rmsd_min.v = apply(rmsd.m, 2, min);
	## vector of row indices of minimal rmsd values
	rmsd_min.ix = sapply(1:length(rmsd_min.v), function(z) {
		which(rmsd.m[ , z] %in% rmsd_min.v[z]);
	})

	## fragment string
	fragstring = fragment.letters[rmsd_min.ix];
	# return string of SA fragments
	return(fragstring);
}

#_______________________________________________________________________________
## encode trajectory with the assigned structural alphabet
.encode_traj = function(sadata_o, str, traj, parallel.calc = TRUE) {
  ## length of the trajectory
  n_frames = length(traj[ , 1]);
  ## number of atoms per conformation
  n_atoms = dim(traj)[2] / 3;

  ## append xyz coordinates of each frame to an element in a list
  traj_xyz = list();
  for (i in seq(from = 1, to = n_frames, by = 1)) {
    prog = (i / n_frames) * 100;
    if (prog %% 10 == 0) {
      print(paste(prog, ' %', sep = ''));
    }

    ## assign the xyz coordinates to a data frame
    coords = as.data.frame(matrix(traj[i, ], nrow = n_atoms, byrow = TRUE));
    names(coords) = c('x', 'y', 'z');
    ## append the coordinates to a list
    traj_xyz[[i]] = coords;
  }

  ## sfragment encoding in parallel mode
  if (parallel.calc == TRUE) {
    ## set number of cores to 1 if machine only has 1 core
    n_det_cores = parallel::detectCores();
    stopifnot(is.integer(n_det_cores) & n_det_cores > 0);
    if (n_det_cores == 1) {
      n_cores = 1;
      print("WARNING: Parallel encoding using a single core:
            potentially slow for large proteins and/or long trajectories.");
    } else {
      ## determine the number of cores on the machine
      n_cores = parallel::detectCores() - 1;
      print(paste("INFO: Parallel encoding using", n_cores, "cores."));
    }

    ## initiate a cluster to encode in parallel
    cluster = parallel::makeCluster(n_cores);

    ## export library to cluster
    parallel::clusterEvalQ(cluster, library("AlloHubMat"));
    ## export ".encode" function
    parallel::clusterExport(cluster, ".encode");
    ## encode the trajectory with the assigned structural alphabet
    sa_traj = pbapply::pblapply(traj_xyz, cl = cluster, function(i, sado = sadata_o) { .encode(i, sado) });

  } else {
    ## sfragment encoding in serial mode
    sa_traj = pbapply::pblapply(traj_xyz, sa_encode, "dcd");
  }

  ## number of fragments in the alignment
  num_frags = num_atoms - 3;

  ## format the structural alphabet strings into a matrix
  sadata_o@sa_trajectory = matrix(unlist(sa_traj), ncol = num_frags, byrow = FALSE);

  ## write the structural alphabet-encoded trajectory to the disk
  saveRDS(sa_traj_mat, paste0(format(Sys.time(), "%Y%m%d_%H%M%S_"), "_sa_trajectory_matrix.rds", sep = ""));

  ## return the structural alphabet-encoded trajectory
  return(sadata_o);
}

#_______________________________________________________________________________
setMethod(f = "sa_encode", signature = c("sadata"), definition = function(x, y, z) {
  .assign_M32K25(x);
  .encode_traj(x, y, z);
})

#===============================================================================
