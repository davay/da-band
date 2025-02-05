import Foundation

// Vector and Quaternion structures
struct Vector3D {
    var x: Float
    var y: Float
    var z: Float
    
    // 106-109
    func normalized() -> Vector3D {
        let norm = sqrt(x * x + y * y + z * z)
        return Vector3D(x: x / norm, y: y / norm, z: z / norm)
    }
}

struct Quaternion {
    var x: Float
    var y: Float
    var z: Float
    var w: Float
    
    // 111-122
    func normalized() -> Quaternion {
        let norm = sqrt(x * x + y * y + z * z + w * w)
        return Quaternion(x: x / norm, y: y / norm, z: z / norm, w: w / norm)
    }
    
    // 136-142
    func conjugate() -> Quaternion {
        return Quaternion(x: -x, y: -y, z: -z, w: w)
    }
    
    // 159-168
    static func * (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            x: lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y,
            y: lhs.w * rhs.y + lhs.y * rhs.w + lhs.z * rhs.x - lhs.x * rhs.z,
            z: lhs.w * rhs.z + lhs.z * rhs.w + lhs.x * rhs.y - lhs.y * rhs.x,
            w: lhs.w * rhs.w - (lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z)
        )
    }
    
    // 170-184
    func rotate(_ v: Vector3D) -> Vector3D {
        let r = Quaternion(x: v.x, y: v.y, z: v.z, w: 0)
        let qConjugate = conjugate()
        let rotated = self * r * qConjugate
        return Vector3D(x: rotated.x, y: rotated.y, z: rotated.z)
    }
}

// MARK: - Functions

// 1-28
func sqrt_f(_ x: Float) -> Float {
    if x < 0 { return -1 }
    if x == 0 { return 0 }
    
    var aa = x
    var bb: Float = 1
    var mult: Float = 1
    var m_iters = 0
    
    while aa > 100 && m_iters+1 < 20 {
        aa *= 0.01
        mult *= 10
        m_iters += 1
    }
    m_iters += 1
    
    while aa < 0.01 && m_iters+1 < 20 {
        aa *= 100
        mult *= 0.1
        m_iters += 1
    }
    m_iters += 1
    
    for _ in 0..<6 {
        let avg = 0.5 * (aa + bb)
        bb *= aa / avg
        aa = avg
    }
    
    return mult * 0.5 * (aa + bb)
}

// 29-54
func sin_f(_ v: Float) -> Float {
    var res: Float = 0
    var v = v
    
    while v < -Float.pi { v += 2 * Float.pi }
    while v > Float.pi { v -= 2 * Float.pi }
    
    if v < 0 {
        res = 1.27323954 * v + 0.405284735 * v * v
        res = res < 0 ? 0.225 * (res * -res - res) + res : 0.225 * (res * res - res) + res
    } else {
        res = 1.27323954 * v - 0.405284735 * v * v
        res = res < 0 ? 0.225 * (res * -res - res) + res : 0.225 * (res * res - res) + res
    }
    return res
}

// 56-59
func cos_f(_ v: Float) -> Float {
    return sin_f(v + Float.pi / 2)
}

// 61-79
func atan2_f(_ y: Float, _ x: Float) -> Float {
    var ax = x
    var ay = y
    if ax < 0 { ax = -ax }
    if ay < 0 { ay = -ay }
    
    var mn = ax
    var mx = ax
    
    if mx < 0.0000001 { return 0 }
    if ay > ax { mx = ay } else { mn = ay }
    
    let a = mn / mx
    let s = a * a
    var r = ((-0.0464964749 * s + 0.15931422) * s - 0.327622764) * s * a + a
    
    if ay > ax { r = Float.pi / 2 - r }
    if x < 0 { r = Float.pi - r }
    if y < 0 { r = -r }
    
    return r
}

// 81-94
func asin_f(_ x: Float) -> Float {
    var sgn: Float = 1
    if x < 0 {
        sgn = -1
    }
    
    let x21 = x * 2 - 1
    let x21_2 = x21 * x21
    let x21_3 = x21 * x21_2
    let x21_4 = x21 * x21_3
    let x21_5 = x21 * x21_4
    let x21_6 = x21 * x21_5
    let res = -0.09902914 + 1.235307 * x + 0.2237106 * x21_2 - 0.1746904 * x21_3 - 0.42491176 * x21_4 + 0.30870647 * x21_5 + 0.4401081 * x21_6
    
    return sgn * res
}

// 96-99
func acos_f(_ x: Float) -> Float {
    return Float.pi * 0.5 - asin_f(x)
}

// 101-104
func q_norm(_ q: Quaternion) -> Float {
    return sqrt_f(q.x * q.x + q.y * q.y + q.z * q.z + q.w * q.w)
}

// 106-109
func v_norm(_ v: Vector3D) -> Float {
    return sqrt_f(v.x * v.x + v.y * v.y + v.z * v.z)
}

// 111-122
func q_renorm(_ q: inout Quaternion) {
    let r = q_norm(q)
    if r > 0 {
        let m = 1.0 / r
        q.x *= m
        q.y *= m
        q.z *= m
        q.w *= m
    }
}

// 124-134
func v_renorm(_ v: inout Vector3D) {
    let r = v_norm(v)
    if r > 0 {
        let m = 1.0 / r
        v.x *= m
        v.y *= m
        v.z *= m
    }
}

// 136-142
func q_set(_ target: inout Quaternion, _ source: Quaternion) {
    target = source
}

// 144-150
func v_set(_ target: inout Vector3D, _ source: Vector3D) {
    target = source
}

// 211-222
func q_from_vectors(u: Vector3D, v: Vector3D) -> Quaternion {
    let d = v_dot(u, v)
    var w = v_cross(u, v)
    let normW = v_norm(w)
    let res = Quaternion(x: w.x, y: w.y, z: w.z, w: d + sqrt_f(d * d + normW * normW))
    return res.normalized()
}

// 206-209
func v_dot(_ v1: Vector3D, _ v2: Vector3D) -> Float {
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
}

// Vector cross product
func v_cross(_ v1: Vector3D, _ v2: Vector3D) -> Vector3D {
    return Vector3D(
        x: v1.y * v2.z - v1.z * v2.y,
        y: v1.z * v2.x - v1.x * v2.z,
        z: v1.x * v2.y - v1.y * v2.x
    )
}



