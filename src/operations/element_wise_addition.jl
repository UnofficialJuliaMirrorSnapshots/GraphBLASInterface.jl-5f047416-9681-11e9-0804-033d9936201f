"""
    GrB_eWiseAdd(C, mask, accum, op, A, B, desc)

Generic method for element-wise matrix and vector operations: using set union.

`GrB_eWiseAdd` computes `C<Mask> = accum (C, A + B)`, where pairs of elements in two matrices (or two vectors)
are pairwise "added". The "add" operator can be any binary operator. With the plus operator,
this is the same matrix addition in conventional linear algebra. The pattern of the result T = A + B is
the set union of A and B. Entries outside of the union are not computed. That is, if both A(i, j) and B(i, j)
are present in the pattern of A and B, then T(i, j) = A(i, j) "+" B(i, j). If only A(i, j) is present
then T(i, j) = A (i, j) and the "+" operator is not used. Likewise, if only B(i, j) is in the pattern of B
but A(i, j) is not in the pattern of A, then T(i, j) = B(i, j). For a semiring, the mult operator is the
semiring's add operator.
"""
GrB_eWiseAdd(C, mask, accum, op::Abstract_GrB_BinaryOp, A::Abstract_GrB_Vector, B, desc) = GrB_eWiseAdd_Vector_BinaryOp(C, mask, accum, op, A, B, desc)
GrB_eWiseAdd(C, mask, accum, op::Abstract_GrB_Monoid, A::Abstract_GrB_Vector, B, desc) = GrB_eWiseAdd_Vector_Monoid(C, mask, accum, op, A, B, desc)
GrB_eWiseAdd(C, mask, accum, op::Abstract_GrB_Semiring, A::Abstract_GrB_Vector, B, desc) = GrB_eWiseAdd_Vector_Semiring(C, mask, accum, op, A, B, desc)
GrB_eWiseAdd(C, mask, accum, op::Abstract_GrB_BinaryOp, A::Abstract_GrB_Matrix, B, desc) = GrB_eWiseAdd_Matrix_BinaryOp(C, mask, accum, op, A, B, desc)
GrB_eWiseAdd(C, mask, accum, op::Abstract_GrB_Monoid, A::Abstract_GrB_Matrix, B, desc) = GrB_eWiseAdd_Matrix_Monoid(C, mask, accum, op, A, B, desc)
GrB_eWiseAdd(C, mask, accum, op::Abstract_GrB_Semiring, A::Abstract_GrB_Matrix, B, desc) = GrB_eWiseAdd_Matrix_Semiring(C, mask, accum, op, A, B, desc)

"""
    GrB_eWiseAdd_Vector_Semiring(w, mask, accum, semiring, u, v, desc)

Compute element-wise vector addition using semiring. Semiring's add operator is used.
`w<mask> = accum (w, u + v)`

# Examples
```jldoctest
julia> using GraphBLASInterface, SuiteSparseGraphBLAS

julia> GrB_init(GrB_NONBLOCKING)
GrB_SUCCESS::GrB_Info = 0

julia> u = GrB_Vector{Int64}()
GrB_Vector{Int64}

julia> GrB_Vector_new(u, GrB_INT64, 5)
GrB_SUCCESS::GrB_Info = 0

julia> I1 = [0, 2, 4]; X1 = [10, 20, 3]; n1 = 3;

julia> GrB_Vector_build(u, I1, X1, n1, GrB_FIRST_INT64)
GrB_SUCCESS::GrB_Info = 0

julia> v = GrB_Vector{Float64}()
GrB_Vector{Float64}

julia> GrB_Vector_new(v, GrB_FP64, 5)
GrB_SUCCESS::GrB_Info = 0

julia> I2 = [0, 1, 4]; X2 = [1.1, 2.2, 3.3]; n2 = 3;

julia> GrB_Vector_build(v, I2, X2, n2, GrB_FIRST_FP64)
GrB_SUCCESS::GrB_Info = 0

julia> w = GrB_Vector{Float64}()
GrB_Vector{Float64}

julia> GrB_Vector_new(w, GrB_FP64, 5)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_eWiseAdd_Vector_Semiring(w, GrB_NULL, GrB_NULL, GxB_PLUS_TIMES_FP64, u, v, GrB_NULL)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_Vector_extractTuples(w)
([0, 1, 2, 4], [11.1, 2.2, 20.0, 6.3])
```
"""
GrB_eWiseAdd_Vector_Semiring(                   # w<Mask> = accum (w, u+v)
    w::Abstract_GrB_Vector,                     # input/output vector for results
    mask::vector_mask_type,                     # optional mask for w, unused if NULL
    accum::accum_type,                          # optional accum for z=accum(w,t)
    semiring::Abstract_GrB_Semiring,            # defines '+' for t=u+v
    u::Abstract_GrB_Vector,                     # first input:  vector u
    v::Abstract_GrB_Vector,                     # second input: vector v
    desc::desc_type                             # descriptor for w and mask
) = _NI("GrB_eWiseAdd_Vector_Semiring")

"""
    GrB_eWiseAdd_Vector_Monoid(w, mask, accum, monoid, u, v, desc)

Compute element-wise vector addition using monoid.
`w<mask> = accum (w, u + v)`

# Examples
```jldoctest
julia> using GraphBLASInterface, SuiteSparseGraphBLAS

julia> GrB_init(GrB_NONBLOCKING)
GrB_SUCCESS::GrB_Info = 0

julia> u = GrB_Vector{Int64}()
GrB_Vector{Int64}

julia> GrB_Vector_new(u, GrB_INT64, 5)
GrB_SUCCESS::GrB_Info = 0

julia> I1 = [0, 2, 4]; X1 = [10, 20, 3]; n1 = 3;

julia> GrB_Vector_build(u, I1, X1, n1, GrB_FIRST_INT64)
GrB_SUCCESS::GrB_Info = 0

julia> v = GrB_Vector{Float64}()
GrB_Vector{Float64}

julia> GrB_Vector_new(v, GrB_FP64, 5)
GrB_SUCCESS::GrB_Info = 0

julia> I2 = [0, 1, 4]; X2 = [1.1, 2.2, 3.3]; n2 = 3;

julia> GrB_Vector_build(v, I2, X2, n2, GrB_FIRST_FP64)
GrB_SUCCESS::GrB_Info = 0

julia> w = GrB_Vector{Float64}()
GrB_Vector{Float64}

julia> GrB_Vector_new(w, GrB_FP64, 5)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_eWiseAdd_Vector_Monoid(w, GrB_NULL, GrB_NULL, GxB_MAX_FP64_MONOID, u, v, GrB_NULL)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_Vector_extractTuples(w)
([0, 1, 2, 4], [10.0, 2.2, 20.0, 3.3])
```
"""
GrB_eWiseAdd_Vector_Monoid(                     # w<Mask> = accum (w, u+v)
    w::Abstract_GrB_Vector,                     # input/output vector for results
    mask::vector_mask_type,                     # optional mask for w, unused if NULL
    accum::accum_type,                          # optional accum for z=accum(w,t)
    monoid::Abstract_GrB_Monoid,                # defines '+' for t=u+v
    u::Abstract_GrB_Vector,                     # first input:  vector u
    v::Abstract_GrB_Vector,                     # second input: vector v
    desc::desc_type                             # descriptor for w and mask
) = _NI("GrB_eWiseAdd_Vector_Monoid")

"""
    GrB_eWiseAdd_Vector_BinaryOp(w, mask, accum, add, u, v, desc)

Compute element-wise vector addition using binary operator.
`w<mask> = accum (w, u + v)`

# Examples
```jldoctest
julia> using GraphBLASInterface, SuiteSparseGraphBLAS

julia> GrB_init(GrB_NONBLOCKING)
GrB_SUCCESS::GrB_Info = 0

julia> u = GrB_Vector{Int64}()
GrB_Vector{Int64}

julia> GrB_Vector_new(u, GrB_INT64, 5)
GrB_SUCCESS::GrB_Info = 0

julia> I1 = [0, 2, 4]; X1 = [10, 20, 3]; n1 = 3;

julia> GrB_Vector_build(u, I1, X1, n1, GrB_FIRST_INT64)
GrB_SUCCESS::GrB_Info = 0

julia> v = GrB_Vector{Float64}()
GrB_Vector{Float64}

julia> GrB_Vector_new(v, GrB_FP64, 5)
GrB_SUCCESS::GrB_Info = 0

julia> I2 = [0, 1, 4]; X2 = [1.1, 2.2, 3.3]; n2 = 3;

julia> GrB_Vector_build(v, I2, X2, n2, GrB_FIRST_FP64)
GrB_SUCCESS::GrB_Info = 0

julia> w = GrB_Vector{Float64}()
GrB_Vector{Float64}

julia> GrB_Vector_new(w, GrB_FP64, 5)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_eWiseAdd_Vector_BinaryOp(w, GrB_NULL, GrB_NULL, GrB_PLUS_FP64, u, v, GrB_NULL)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_Vector_extractTuples(w)
([0, 1, 2, 4], [11.1, 2.2, 20.0, 6.3])
```
"""
GrB_eWiseAdd_Vector_BinaryOp(                   # w<Mask> = accum (w, u+v)
    w::Abstract_GrB_Vector,                     # input/output vector for results
    mask::vector_mask_type,                     # optional mask for w, unused if NULL
    accum::accum_type,                          # optional accum for z=accum(w,t)
    add::Abstract_GrB_BinaryOp,                 # defines '+' for t=u+v
    u::Abstract_GrB_Vector,                     # first input:  vector u
    v::Abstract_GrB_Vector,                     # second input: vector v
    desc::desc_type                             # descriptor for w and mask
) = _NI("GrB_eWiseAdd_Vector_BinaryOp")

"""
    GrB_eWiseAdd_Matrix_Semiring(C, Mask, accum, semiring, A, B, desc)

Compute element-wise matrix addition using semiring. Semiring's add operator is used.
`C<Mask> = accum (C, A + B)`

# Examples
```jldoctest
julia> using GraphBLASInterface, SuiteSparseGraphBLAS

julia> GrB_init(GrB_NONBLOCKING)
GrB_SUCCESS::GrB_Info = 0

julia> A = GrB_Matrix{Int64}()
GrB_Matrix{Int64}

julia> GrB_Matrix_new(A, GrB_INT64, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> I1 = [0, 0, 2, 2]; J1 = [1, 2, 0, 2]; X1 = [10, 20, 30, 40]; n1 = 4;

julia> GrB_Matrix_build(A, I1, J1, X1, n1, GrB_FIRST_INT64)
GrB_SUCCESS::GrB_Info = 0

julia> B = GrB_Matrix{Int64}()
GrB_Matrix{Int64}

julia> GrB_Matrix_new(B, GrB_INT64, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> I2 = [0, 0, 2]; J2 = [3, 2, 0]; X2 = [15, 16, 17]; n2 = 3;

julia> GrB_Matrix_build(B, I2, J2, X2, n2, GrB_FIRST_INT64)
GrB_SUCCESS::GrB_Info = 0

julia> C = GrB_Matrix{Int64}()
GrB_Matrix{Int64}

julia> GrB_Matrix_new(C, GrB_INT64, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_eWiseAdd_Matrix_Semiring(C, GrB_NULL, GrB_NULL, GxB_PLUS_TIMES_INT64, A, B, GrB_NULL)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_Matrix_extractTuples(C)
([0, 0, 0, 2, 2], [1, 2, 3, 0, 2], [10, 36, 15, 47, 40])
```
"""
GrB_eWiseAdd_Matrix_Semiring(                   # C<Mask> = accum (C, A+B)
    C::Abstract_GrB_Matrix,                     # input/output matrix for results
    Mask::matrix_mask_type,                     # optional mask for C, unused if NULL
    accum::accum_type,                          # optional accum for Z=accum(C,T)
    semiring::Abstract_GrB_Semiring,            # defines '+' for T=A+B
    A::Abstract_GrB_Matrix,                     # first input:  matrix A
    B::Abstract_GrB_Matrix,                     # second input: matrix B
    desc::desc_type                             # descriptor for C, Mask, A, and B
) = _NI("GrB_eWiseAdd_Matrix_Semiring")

"""
    GrB_eWiseAdd_Matrix_Monoid(C, Mask, accum, monoid, A, B, desc)

Compute element-wise matrix addition using monoid.
`C<Mask> = accum (C, A + B)`

# Examples
```jldoctest
julia> using GraphBLASInterface, SuiteSparseGraphBLAS

julia> GrB_init(GrB_NONBLOCKING)
GrB_SUCCESS::GrB_Info = 0

julia> A = GrB_Matrix{Int64}()
GrB_Matrix{Int64}

julia> GrB_Matrix_new(A, GrB_INT64, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> I1 = [0, 0, 2, 2]; J1 = [1, 2, 0, 2]; X1 = [10, 20, 30, 40]; n1 = 4;

julia> GrB_Matrix_build(A, I1, J1, X1, n1, GrB_FIRST_INT64)
GrB_SUCCESS::GrB_Info = 0

julia> B = GrB_Matrix{Int64}()
GrB_Matrix{Int64}

julia> GrB_Matrix_new(B, GrB_INT64, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> I2 = [0, 0, 2]; J2 = [3, 2, 0]; X2 = [15, 16, 17]; n2 = 3;

julia> GrB_Matrix_build(B, I2, J2, X2, n2, GrB_FIRST_INT64)
GrB_SUCCESS::GrB_Info = 0

julia> C = GrB_Matrix{Int64}()
GrB_Matrix{Int64}

julia> GrB_Matrix_new(C, GrB_INT64, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> mask = GrB_Matrix{Bool}()
GrB_Matrix{Bool}

julia> GrB_Matrix_new(mask, GrB_BOOL, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_Matrix_build(mask, [0, 0], [1, 2], [true, true], 2, GrB_FIRST_BOOL)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_eWiseAdd_Matrix_Monoid(C, mask, GrB_NULL, GxB_PLUS_INT64_MONOID, A, B, GrB_NULL)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_Matrix_extractTuples(C)
([0, 0], [1, 2], [10, 36])
```
"""
GrB_eWiseAdd_Matrix_Monoid(                     # C<Mask> = accum (C, A+B)
    C::Abstract_GrB_Matrix,                     # input/output matrix for results
    Mask::matrix_mask_type,                     # optional mask for C, unused if NULL
    accum::accum_type,                          # optional accum for Z=accum(C,T)
    monoid::Abstract_GrB_Monoid,                # defines '+' for T=A+B
    A::Abstract_GrB_Matrix,                     # first input:  matrix A
    B::Abstract_GrB_Matrix,                     # second input: matrix B
    desc::desc_type                             # descriptor for C, Mask, A, and B
) = _NI("GrB_eWiseAdd_Matrix_Monoid")

"""
    GrB_eWiseAdd_Matrix_BinaryOp(C, Mask, accum, add, A, B, desc)

Compute element-wise matrix addition using binary operator.
`C<Mask> = accum (C, A + B)`

# Examples
```jldoctest
julia> using GraphBLASInterface, SuiteSparseGraphBLAS

julia> GrB_init(GrB_NONBLOCKING)
GrB_SUCCESS::GrB_Info = 0

julia> A = GrB_Matrix{Int64}()
GrB_Matrix{Int64}

julia> GrB_Matrix_new(A, GrB_INT64, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> I1 = [0, 0, 2, 2]; J1 = [1, 2, 0, 2]; X1 = [10, 20, 30, 40]; n1 = 4;

julia> GrB_Matrix_build(A, I1, J1, X1, n1, GrB_FIRST_INT64)
GrB_SUCCESS::GrB_Info = 0

julia> B = GrB_Matrix{Int64}()
GrB_Matrix{Int64}

julia> GrB_Matrix_new(B, GrB_INT64, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> I2 = [0, 0, 2]; J2 = [3, 2, 0]; X2 = [15, 16, 17]; n2 = 3;

julia> GrB_Matrix_build(B, I2, J2, X2, n2, GrB_FIRST_INT64)
GrB_SUCCESS::GrB_Info = 0

julia> C = GrB_Matrix{Int64}()
GrB_Matrix{Int64}

julia> GrB_Matrix_new(C, GrB_INT64, 4, 4)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_eWiseAdd_Matrix_BinaryOp(C, GrB_NULL, GrB_NULL, GrB_PLUS_INT64, A, B, GrB_NULL)
GrB_SUCCESS::GrB_Info = 0

julia> GrB_Matrix_extractTuples(C)
([0, 0, 0, 2, 2], [1, 2, 3, 0, 2], [10, 36, 15, 47, 40])
```
"""
GrB_eWiseAdd_Matrix_BinaryOp(                   # C<Mask> = accum (C, A+B)
    C::Abstract_GrB_Matrix,                     # input/output matrix for results
    Mask::matrix_mask_type,                     # optional mask for C, unused if NULL
    accum::accum_type,                          # optional accum for Z=accum(C,T)
    add::Abstract_GrB_BinaryOp,                 # defines '+' for T=A+B
    A::Abstract_GrB_Matrix,                     # first input:  matrix A
    B::Abstract_GrB_Matrix,                     # second input: matrix B
    desc::desc_type                             # descriptor for C, Mask, A, and B
) = _NI("GrB_eWiseAdd_Matrix_BinaryOp")
