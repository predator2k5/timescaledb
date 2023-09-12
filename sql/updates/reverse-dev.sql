DROP FUNCTION _timescaledb_functions.compressed_data_info(_timescaledb_internal.compressed_data);
DROP INDEX _timescaledb_catalog.compression_chunk_size_idx;
DROP FUNCTION IF EXISTS _timescaledb_functions.drop_osm_chunk(REGCLASS);

-- Hyperstore AM
DROP ACCESS METHOD IF EXISTS tscompression;
DROP FUNCTION IF EXISTS ts_compressionam_handler;
