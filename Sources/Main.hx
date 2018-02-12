package;

import haxebullet.Bullet;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		System.init({title: "Project", width: 1024, height: 768}, function () {
			#if js
			haxe.macro.Compiler.includeFile("../Libraries/Bullet/js/ammo/ammo.js");
			#end
			initPhysics();
			System.notifyOnRender(render);
			Scheduler.addTimeTask(update, 0, 1 / 60);
		});
	}

	static var dynamicsWorld: BtDynamicsWorld;
	static var fallRigidBody: BtRigidBody;

	static function initPhysics(): Void {
		var collisionConfiguration = new BtDefaultCollisionConfiguration();
		var dispatcher = new BtCollisionDispatcher(collisionConfiguration);
		var broadphase = new BtDbvtBroadphase();
		var solver = new BtSequentialImpulseConstraintSolver();
		dynamicsWorld = new BtDynamicsWorld(dispatcher, broadphase, solver, collisionConfiguration);

		var groundShape = BtStaticPlaneShape.create(BtVector3.create(0, 1, 0).value, 1);
		var groundTransform = BtTransform.create();
		groundTransform.value.setIdentity();
		groundTransform.value.setOrigin(BtVector3.create(0, -1, 0).value);
		var centerOfMassOffsetTransform = BtTransform.create();
		centerOfMassOffsetTransform.value.setIdentity();
		var groundMotionState = BtDefaultMotionState.create(groundTransform.value, centerOfMassOffsetTransform.value);

		var groundRigidBodyCI = BtRigidBodyConstructionInfo.create(0.01, groundMotionState, groundShape, BtVector3.create(0, 0, 0).value);
		var groundRigidBody = BtRigidBody.create(groundRigidBodyCI.value);
		dynamicsWorld.addRigidBody(groundRigidBody);

		var fallShape = BtSphereShape.create(1);
		var fallTransform = BtTransform.create();
		fallTransform.value.setIdentity();
		fallTransform.value.setOrigin(BtVector3.create(0, 50, 0).value);
		var centerOfMassOffsetFallTransform = BtTransform.create();
		centerOfMassOffsetFallTransform.value.setIdentity();
		var fallMotionState = BtDefaultMotionState.create(fallTransform.value, centerOfMassOffsetFallTransform.value);

		var fallInertia = BtVector3.create(0, 0, 0);
		fallShape.value.calculateLocalInertia(1, fallInertia.value);
		var fallRigidBodyCI = BtRigidBodyConstructionInfo.create(1, fallMotionState, fallShape, fallInertia.value);
		fallRigidBody = BtRigidBody.create(fallRigidBodyCI.value);
		dynamicsWorld.addRigidBody(fallRigidBody);
	}

	static function update(): Void {
		dynamicsWorld.stepSimulation(1 / 60);
	
		var trans = BtTransform.create();
		var m = fallRigidBody.value.getMotionState();
		m.getWorldTransform(trans.value);
		trace(trans.getOrigin().y());
	}

	static function render(framebuffer: Framebuffer): Void {
		
	}
}
