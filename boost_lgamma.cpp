
#include <boost/math/special_functions/gamma.hpp>


#include <iostream>


int main(int argc, char** argv)
{
    double z = 1.4;
    double coef[] = {1,2,3};
    std::cout << boost::math::lgamma(z) << '\n';
    std::cout << boost::math::tools::evaluate_polynomial(coef,10) << '\n';
    return 0;
}
