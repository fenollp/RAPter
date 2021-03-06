#ifndef CYLINDERPRIMITIVESHAPECONSTRUCTOR_HEADER
#define CYLINDERPRIMITIVESHAPECONSTRUCTOR_HEADER
#include "PrimitiveShapeConstructor.h"
#include "CylinderPrimitiveShape.h"

#ifndef DLL_LINKAGE
#define DLL_LINKAGE
#endif

namespace schnabel {

class DLL_LINKAGE CylinderPrimitiveShapeConstructor
: public PrimitiveShapeConstructor
{
	public:
		size_t Identifier() const;
		unsigned int RequiredSamples() const;
		PrimitiveShape *Construct(const MiscLib::Vector< Vec3f > &points,
			const MiscLib::Vector< Vec3f > &normals) const;
		PrimitiveShape *Construct(const MiscLib::Vector< Vec3f > &samples) const;
		PrimitiveShape *Deserialize(std::istream *i, bool binary = true) const;
		size_t SerializedSize() const;
};

} //...ns schnabel

#endif
