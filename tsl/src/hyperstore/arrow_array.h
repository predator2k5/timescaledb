/*
 * This file and its contents are licensed under the Timescale License.
 * Please see the included NOTICE for copyright information and
 * LICENSE-TIMESCALE for a copy of the license.
 */

#ifndef HYPERSTORE_ARROW_ARRAY_H_
#define HYPERSTORE_ARROW_ARRAY_H_

#include <postgres.h>

#include "compression/compression.h"

extern ArrowArray *arrow_create_with_buffers(MemoryContext mcxt, int n_buffers);
extern ArrowArray *arrow_from_iterator(MemoryContext mcxt, DecompressionIterator *iterator,
									   Oid typid);
extern NullableDatum arrow_get_datum(ArrowArray *array, Oid typid, int64 index);
extern void arrow_release_buffers(ArrowArray *array);
extern ArrowArray *default_decompress_all(Datum compressed, Oid element_type,
										  MemoryContext dest_mctx);

#define TYPLEN_VARLEN (-1)
#define TYPLEN_CSTRING (-2)

#endif /* HYPERSTORE_ARROW_ARRAY_H_ */
