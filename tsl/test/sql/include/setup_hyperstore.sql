-- This file and its contents are licensed under the Timescale License.
-- Please see the included NOTICE for copyright information and
-- LICENSE-TIMESCALE for a copy of the license.

\set hypertable readings

-- Alternative function to compress_chunk that uses the table access
-- method to compress a chunk.
create function twist_chunk(chunk regclass) returns regclass language plpgsql
as $$
begin
    execute format('alter table %s set access method hyperstore', chunk);
    return chunk;
end
$$;

create function untwist_chunk(chunk regclass) returns regclass language plpgsql
as $$
begin
    execute format('alter table %s set access method heap', chunk);
    return chunk;
end
$$;

create table :hypertable(
       metric_id serial,
       created_at timestamptz not null unique,
       location_id int,
       device_id int,
       temp float,
       humidity float
);

select create_hypertable(:'hypertable', by_range('created_at'));
-- Disable incremental sort to make tests stable
set enable_incremental_sort = false;
select setseed(1);

-- Insert rows into the tables.
--
-- The timestamps for the original rows will have timestamps every 10
-- seconds. Any other timestamps are inserted as part of the test.
insert into :hypertable (created_at, location_id, device_id, temp, humidity)
select t, ceil(random()*10), ceil(random()*30), random()*40, random()*100
from generate_series('2022-06-01'::timestamptz, '2022-07-01', '10s') t;

alter table :hypertable set (
	  timescaledb.compress,
	  timescaledb.compress_orderby = 'created_at',
	  timescaledb.compress_segmentby = 'location_id'
);

-- Set some test chunks as global variables (first and last chunk here)
select format('%I.%I', chunk_schema, chunk_name)::regclass as chunk1
  from timescaledb_information.chunks
 where format('%I.%I', hypertable_schema, hypertable_name)::regclass = :'hypertable'::regclass
 order by chunk1 asc
 limit 1 \gset

select format('%I.%I', chunk_schema, chunk_name)::regclass as chunk2
  from timescaledb_information.chunks
 where format('%I.%I', hypertable_schema, hypertable_name)::regclass = :'hypertable'::regclass
 order by chunk2 desc
 limit 1 \gset
