# makeMatrix makes a special matrix object whose inverse can be cached using
# cacheSolve. These functions work by taking advantage of lexical scoping in R. 

# The makeMatrix() func returns an object of type list() that allows access
# to other objects (x,m) thru getters and setters. Test code using:
#   m1<-matrix(c(1/2, -1/4, -1, 3/4), nrow = 2, ncol = 2)
#   aMatrix<-makeMatrix(m1)
#   m2<-cacheSolve(aMatrix)
# The cacheSolve() func calculates m2 (the inverse of m1) or if called a
# again returns m2 from the cached value, along with a 'getting cache' message
# Setting a new matrix using aMatrix$set(m2) will calculate its inverse, m1

makeMatrix <- function(x = matrix()) {
  inv <- NULL
  set <- function(y) {
    x <<- y
    inv<<- NULL
  }
  get <- function() x
  setInverse <- function(i) inv <<- i
  getInverse <- function() inv
  list(set = set, get = get,
       setInverse = setInverse,
       getInverse = getInverse)
}

cacheSolve <- function(x, ...) {
  inv <- x$getInverse()
  if(!is.null(inv)) {
    message("getting cached data")
    return(inv)
  }
  data <- x$get()
  inv <- solve(data, ...)
  x$setInverse(inv)
  inv
}