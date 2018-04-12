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

makeMatrix <- function(x = matrix()) {   # initialize x as empty matrix
  inv <- NULL                     # initialze inv of x as null
  set <- function(y) {            # assign values to x, inv of parent environment
    x <<- y 
    inv<<- NULL
  }
  get <- function() x                   # returns x when called with aMatrix$get
  setInverse <- function(i) inv <<- i   # assigns
  getInverse <- function() inv          # returns inv w/ aMatrix$getInverse()
  list(set = set, get = get,            # this list() allows access to x,inv,
       setInverse = setInverse,         # and the 4 getter/setter functions
       getInverse = getInverse)         # named elements allow use of $ notation
}

cacheSolve <- function(x, ...) {        # the input x must be of type makeMatrix
  inv <- x$getInverse()                 # first get cached inv matrix if avail
  if(!is.null(inv)) {                   # cached inv is avail if inv is not null
    message("getting cached data")      # notice that no calculation is needed
    return(inv)                         # cached inv being returned
  }
  data <- x$get()                       # no cached inv so get matrix data
  inv <- solve(data, ...)               # calculate matrix inverse
  x$setInverse(inv)                     # update cached value of inv
  inv                                   # return calculated inv
}