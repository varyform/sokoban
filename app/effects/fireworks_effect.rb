module FireworksEffect
  DISSOLVE_SPEED = 2
  DEG2RAD = Math::PI / 180

  class << self
    def emit_particle(sys)
      {
        x: sys.x + rand(20),
        y: sys.y + rand(20),
        w: 2,
        h: 2,
        angle: 0,
        dir: rand(360),
        r: rand(255),
        g: rand(255),
        b: rand(255),
        a: 150,
        path: :pixel,
        blendmode_enum: 2
      }
    end

    def tick(particle, sys)
      sys.particles.delete(particle) if dead_particle?(particle)

      particle.x += 1.5 * (Math.cos(particle.dir * DEG2RAD) - 0) / DISSOLVE_SPEED
      particle.y += 1.5 * (Math.sin(particle.dir * DEG2RAD) - 0) / DISSOLVE_SPEED
      particle.angle += particle.dir < 180 ? -0.5 : 0.5
      # particle.angle += [-5, 5].sample
      particle.h += 0.3 / DISSOLVE_SPEED
      particle.w += 0.3 / DISSOLVE_SPEED
      particle.a -= DISSOLVE_SPEED
    end

    def dead_particle?(particle)
      particle.a <= 0
    end
  end
end
