
#ifndef _JIMIC_BASIC_ASSERT_H_
#define _JIMIC_BASIC_ASSERT_H_

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include <assert.h>

#undef JIMIC_USE_ASSERT

#if defined(_DEBUG) || !defined(NDEBUG)
#define JIMIC_USE_ASSERT    1
#else
#define JIMIC_USE_ASSERT    0
#endif  /* _DEBUG || !NDEBUG */

/* For JIMIC_ASSERT_EX */

#if JIMIC_USE_ASSERT

#ifndef JIMIC_ASSERT_MARCO
//#define JIMIC_ASSERT_MARCO(predicate, message) \
//    ((predicate) ? ((void)0) : jimic_assertion_failure(__FILE__, __LINE__, #predicate, message))
#define JIMIC_ASSERT_MARCO(predicate, message)      assert((predicate))
#endif

#ifndef JIMIC_ASSERT
#define JIMIC_ASSERT_TRUE(predicate)                JIMIC_ASSERT_MARCO(!(predicate),  NULL)
#define JIMIC_ASSERT_FALSE(predicate)               JIMIC_ASSERT_MARCO(!!(predicate), NULL)
#define JIMIC_ASSERT(predicate)                     JIMIC_ASSERT_FALSE(predicate)
#endif

#ifndef JIMIC_ASSERT_EX
#define JIMIC_ASSERT_EX_TRUE(predicate, comment)    JIMIC_ASSERT_MARCO(!(predicate),  comment)
#define JIMIC_ASSERT_EX_FALSE(predicate, comment)   JIMIC_ASSERT_MARCO(!!(predicate), comment)
#define JIMIC_ASSERT_EX(predicate, comment)         JIMIC_ASSERT_EX_FALSE(predicate,  comment)
#endif

#else  /* !JIMIC_USE_ASSERT */

//! No-op version of JIMIC_ASSERT.
#define JIMIC_ASSERT_TRUE(predicate)                ((void)0)
#define JIMIC_ASSERT_FALSE(predicate)               ((void)0)
#define JIMIC_ASSERT(predicate)                     JIMIC_ASSERT_FALSE(predicate)

//! "Extended" version is useful to suppress warnings if a variable is only used with an assert
#define JIMIC_ASSERT_EX_TRUE(predicate, comment)    ((void)0)
#define JIMIC_ASSERT_EX_FALSE(predicate, comment)   ((void)0)
#define JIMIC_ASSERT_EX(predicate, comment)         JIMIC_ASSERT_EX_FALSE(predicate, comment)

#endif  /* !JIMIC_USE_ASSERT */

#endif  /* !_JIMIC_BASIC_ASSERT_H_ */
