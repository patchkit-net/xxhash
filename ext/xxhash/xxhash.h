#include <ruby.h>
#include "libxxhash.h"

// Use this typedef to make the compiler happy when
// calling rb_define_method()
typedef VALUE (ruby_method)();

VALUE xxhash_xxh32(VALUE mod, VALUE input, VALUE seed);
void xxhash32_streaming_hash_free(XXH32_state_t* state);
VALUE xxhash32_streaming_hash_new(VALUE klass, VALUE seed);
VALUE xxhash32_streaming_hash_update(VALUE self, VALUE data);
VALUE xxhash32_streaming_hash_digest(VALUE self);
VALUE xxhash_xxh64(VALUE mod, VALUE input, VALUE seed);
void xxhash64_streaming_hash_free(XXH64_state_t* state);
VALUE xxhash64_streaming_hash_new(VALUE klass, VALUE seed);
VALUE xxhash64_streaming_hash_update(VALUE self, VALUE data);
VALUE xxhash64_streaming_hash_digest(VALUE self);
void Init_xxhash(void);
